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

class StudyViewModel: ObservableObject {
    private let deckRepository: DeckRepositoryProtocol
    private let sessionCacher: SessionCacher
    private let dateHandler: DateHandlerProtocol
    let deck: Deck
    
    @Published private var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var shouldButtonsBeDisabled: Bool = true
    
    init(
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
        
        $cards.map { cards in
            return Array(cards.prefix(2))
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
                .print()
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
        
    }
    
    private func receiveCards(todayReviewingCards: [Card], todayLearningCards: [Card], toModify: [Card]) {
        cards = todayLearningCards + todayReviewingCards
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
        guard let card = cards.last else { return }
        let cardDestiny: CardDestiny
        
        do {
            #warning("number of steps tem qu ser guardado em spacedRepConfig em deck")
            cardDestiny =  try Woodpecker.stepper(cardInfo: card.woodpeckerCardInfo, userGrade: userGrade, numberOfSteps: 3)
        } catch {
            print("FODEU")
            return
        }
        
        var updatedCard = card
        
        switch cardDestiny {
        case .back:
            updatedCard.woodpeckerCardInfo.step -= 1
        case .stay:
            print("ok")
        case .foward:
            updatedCard.woodpeckerCardInfo.step += 1
        case .graduate:
            updatedCard.woodpeckerCardInfo.step = 0
            updatedCard.woodpeckerCardInfo.isGraduated = true
        }
        
        do {
            try deckRepository.editCard(updatedCard)
        } catch {
            print("FODEU2")
        }
    }
}
