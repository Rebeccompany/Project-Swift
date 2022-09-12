//
//  File.swift
//  
//
//  Created by Marcos Chevis on 05/09/22.
//

import Foundation
import Storage
import Models
import Woodpecker
import Combine

public class StudyViewModel: ObservableObject {
    private let deckRepository: DeckRepositoryProtocol
    private let sessionCacher: SessionCacher
    private let dateHandler: DateHandlerProtocol
    let deck: Deck
    
    @Published private var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    private var cardsToEdit: [Card] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var shouldButtonsBeDisabled: Bool = true
    
    public init(
        deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil),
        sessionCacher: SessionCacher = SessionCacher(),
        deck: Deck,
        dateHandler: DateHandlerProtocol = DateHandler()
    ) {
        self.deckRepository = deckRepository
        self.sessionCacher = sessionCacher
        self.deck = deck
        self.dateHandler = dateHandler
    }
    
    func startup() {
        
        $cards.map { cards -> [Card] in
            Array(cards.prefix(2).reversed())
        }
        .map { cards in
            cards.map(CardViewModel.init)
        }
        .assign(to: &$displayedCards)
        
        $displayedCards.map { cards in
            !(cards.last?.isFlipped ?? true)
        }
        .assign(to: &$shouldButtonsBeDisabled)
        
        
        if let session = sessionCacher.currentSession(for: deck.id), dateHandler.isToday(date: session.date) {
            deckRepository.fetchCardsByIds(session.cardIds)
                .replaceError(with: [])
                .assign(to: &$cards)
            
        } else {
            deckRepository.fetchCardsByIds(deck.cardsIds)
                .map { $0.map(OrganizerCardInfo.init(card:)) }
                .tryMap { [deck, dateHandler] cards in
                    try Woodpecker.scheduler(cardsInfo: cards, config: deck.spacedRepetitionConfig, currentDate: dateHandler.today)
                }
                .handleEvents(receiveOutput: saveCardIdsToCache)
                .mapError {_ in
                    RepositoryError.internalError
                }
                .flatMap(transformIdsIntoPublishers)
                .sink(receiveCompletion: finishFetchCards, receiveValue: receiveCards)
                .store(in: &cancellables)
        }
    }
    private func finishFetchCards(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            print("aiai")
        case .failure(let error):
            print(error)
        }
    }
    
    private func receiveCards(todayReviewingCards: [Card], todayLearningCards: [Card], toModify: [Card]) {
        cards = todayLearningCards + todayReviewingCards
        cardsToEdit = toModify.map { card in
            var newCard = card
            newCard.dueDate = dateHandler.dayAfterToday(1)
            return newCard
        }
    }
    
    private func transformIdsIntoPublishers(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID])) -> AnyPublisher<([Card], [Card], [Card]), RepositoryError> {
        Publishers.CombineLatest3(deckRepository.fetchCardsByIds(ids.todayLearningCards),
                                  deckRepository.fetchCardsByIds(ids.todayReviewingCards),
                                  deckRepository.fetchCardsByIds(ids.toModify))
        .eraseToAnyPublisher()
    }
    
    private func saveCardIdsToCache(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) ) {
        let session = Session(cardIds: ids.todayReviewingCards + ids.todayLearningCards, date: dateHandler.today, deckId: deck.id)
        sessionCacher.setCurrentSession(session: session)
    }
    
    func pressedButton(for userGrade: UserGrade) {
        guard let newCard = cards.first else { return }
        
        if newCard.woodpeckerCardInfo.isGraduated {
            dealWithSm2Card(userGrade: userGrade)
        } else {
            dealWithSteppedCard(userGrade: userGrade)
        }
        
        cards = cards.prefix(2) + cards.suffix(from: 2).shuffled()
    }
    
    private func dealWithSm2Card(userGrade: UserGrade) {
        var newInfo: WoodpeckerCardInfo = cards[0].woodpeckerCardInfo
        do {
            newInfo = try Woodpecker.wpSm2(cards[0].woodpeckerCardInfo, userGrade: userGrade)
        } catch {
            print("FODEU3")
        }
        
        // modifica o cards[0], salva ele em cardsToEdit, depois remove da lista de cards.
        cards[0].woodpeckerCardInfo = newInfo
        removeCard(shouldAddToEdit: true)
    }
    
    private func dealWithSteppedCard(userGrade: UserGrade) {
        var newCard = cards[0]
        do {
#warning("number of steps tem qu ser guardado em spacedRepConfig em deck")
            let cardDestiny = try Woodpecker.stepper(cardInfo: newCard.woodpeckerCardInfo, userGrade: userGrade, numberOfSteps: 3)
            
            switch cardDestiny {
            case .back:
                //update card and bumps to last position of the vector.
                newCard.woodpeckerCardInfo.step -= 1
                removeCard()
                cards.append(newCard)
            case .stay:
                //update card and bumps to last position of the vector.
                removeCard()
                cards.append(newCard)
            case .foward:
                //update card and bumps to last position of the vector.
                newCard.woodpeckerCardInfo.step += 1
                removeCard()
                cards.append(newCard)
            case .graduate:
                //update card. Save it to toEdit. Remove from cards.
                cards[0].woodpeckerCardInfo.step = 0
                cards[0].woodpeckerCardInfo.isGraduated = true
                
                removeCard(shouldAddToEdit: true)
            }
        } catch {
            print("FODEU")
        }
    }
    
    private func removeCard(shouldAddToEdit: Bool = false) {
        if cards.count >= 1 {
            if shouldAddToEdit {
                cardsToEdit.append(cards[0])
            }
            cards.remove(at: 0)
        }
    }
}
