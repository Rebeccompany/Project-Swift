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
#warning("Chamar saveChanges ao sair da tela")
public class StudyViewModel: ObservableObject {
    private let deckRepository: DeckRepositoryProtocol
    private let sessionCacher: SessionCacher
    private let dateHandler: DateHandlerProtocol
    let deck: Deck
    let cardSortingFunc: (Card, Card) -> Bool
    
    @Published var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    var cardsToEdit: [Card] = []

    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var shouldButtonsBeDisabled: Bool = true
    
    private var timefromLastCard: Date
    
    func saveChanges() {
        do {
            try cardsToEdit.forEach { card in
                try deckRepository.editCard(card)
            }
        } catch {
            print("FODEU4")
        }
        sessionCacher.setCurrentSession(session: Session(cardIds: cards.map(\.id), date: dateHandler.today, deckId: deck.id))
        
    }
    
    
    public init(
        deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil),
        sessionCacher: SessionCacher = SessionCacher(),
        deck: Deck,
        dateHandler: DateHandlerProtocol = DateHandler(),
        cardSortingFunc: @escaping (Card, Card) -> Bool = Woodpecker.cardSorter
    ) {
        self.deckRepository = deckRepository
        self.sessionCacher = sessionCacher
        self.deck = deck
        self.dateHandler = dateHandler
        self.cardSortingFunc = cardSortingFunc
        self.timefromLastCard = dateHandler.today
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
                .map {
                    $0.sorted(by: self.cardSortingFunc)
                }
                .assign(to: &$cards)
            
        } else {
            deckRepository.fetchCardsByIds(deck.cardsIds)
                .map {
                    $0.map(OrganizerCardInfo.init(card:))
                }
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
        cards = (todayLearningCards + todayReviewingCards).sorted(by: cardSortingFunc)
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
        var lastCards: [Card] = []
        if cards.count > 2 {
            lastCards = cards.suffix(from: 2).sorted(by: cardSortingFunc)
        }
        
        timefromLastCard = dateHandler.today
        cards = cards.prefix(2) + lastCards
    }
    
    private func dealWithSm2Card(userGrade: UserGrade) {
        var newInfo: WoodpeckerCardInfo = cards[0].woodpeckerCardInfo
        do {
            newInfo = try Woodpecker.wpSm2(cards[0].woodpeckerCardInfo, userGrade: userGrade)
        } catch {
            print("FODEU3")
        }
        
        // modifica o cards[0], salva ele em cardsToEdit, depois remove da lista de cards.
        cards[0].history.append(CardSnapshot(woodpeckerCardInfo: cards[0].woodpeckerCardInfo, userGrade: userGrade, timeSpend: dateHandler.today.timeIntervalSince1970 - timefromLastCard.timeIntervalSince1970, date: dateHandler.today))
        cards[0].woodpeckerCardInfo = newInfo
        cards[0].woodpeckerCardInfo.hasBeenPresented = true
        removeCard(shouldAddToEdit: true)
    }
    
    private func dealWithSteppedCard(userGrade: UserGrade) {
        var newCard = cards[0]
        newCard.woodpeckerCardInfo.hasBeenPresented = true
        do {
#warning("number of steps tem que ser guardado em spacedRepConfig em deck")
            let cardDestiny = try Woodpecker.stepper(cardInfo: newCard.woodpeckerCardInfo, userGrade: userGrade, numberOfSteps: 3)
            
            switch cardDestiny {
            case .back:
                //update card and bumps to last position of the vector.
                newCard.woodpeckerCardInfo.step -= 1
                newCard.woodpeckerCardInfo.streak = 0
                removeCard()
                cards.append(newCard)
            case .stay:
                //update card and bumps to last position of the vector.
                newCard.woodpeckerCardInfo.streak = 0
                removeCard()
                cards.append(newCard)
            case .foward:
                //update card and bumps to last position of the vector.
                newCard.woodpeckerCardInfo.step += 1
                newCard.woodpeckerCardInfo.streak += 1
                removeCard()
                cards.append(newCard)
            case .graduate:
                //update card. Save it to toEdit. Remove from cards.
                cards[0].history.append(CardSnapshot(woodpeckerCardInfo: cards[0].woodpeckerCardInfo, userGrade: userGrade, timeSpend: dateHandler.today.timeIntervalSince1970 - timefromLastCard.timeIntervalSince1970, date: dateHandler.today))
                cards[0].woodpeckerCardInfo.streak += 1
                cards[0].woodpeckerCardInfo.step = 0
                cards[0].woodpeckerCardInfo.isGraduated = true
                cards[0].woodpeckerCardInfo.hasBeenPresented = true
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
