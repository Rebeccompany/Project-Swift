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
    private let deck: Deck
    @Published private var cards: [Card] = []
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil), sessionCacher: SessionCacher = SessionCacher(), deck: Deck) {
        self.deckRepository = deckRepository
        self.sessionCacher = sessionCacher
        self.deck = deck
    }
    
    func startup() {
        if let session = sessionCacher.currentSession(for: deck.id), isToday(date: session.date) {
            deckRepository.fetchCardsByIds(session.cardIds)
                .replaceError(with: [])
                .assign(to: &$cards)
            
        } else {
            deckRepository.fetchCardsByIds(deck.cardsIds)
                .map { $0.map(OrganizerCardInfo.init(card:)) }
                .tryMap { [deck] cards in
                    try Woodpecker.scheduler(cardsInfo: cards, config: deck.spacedRepetitionConfig)
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
        
    }
    
    private func transformIdsIntoPublishers(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID])) -> AnyPublisher<([Card], [Card], [Card]), RepositoryError> {
        Publishers.CombineLatest3(deckRepository.fetchCardsByIds(ids.todayLearningCards),
                                  deckRepository.fetchCardsByIds(ids.todayReviewingCards),
                                  deckRepository.fetchCardsByIds(ids.toModify))
        .eraseToAnyPublisher()
        
        
    }
    
    private func saveCardIdsToCache(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) ) {
        let session = Session(cardIds: ids.todayReviewingCards + ids.todayLearningCards, date: Date(), deckId: deck.id)
        sessionCacher.setCurrentSession(session: session)
    }
    
    private func isToday(date: Date, today: Date = Date()) -> Bool {
        var cal = Calendar(identifier: .gregorian)
        guard let timezone = TimeZone(identifier: "UTC") else {
            return false
        }
        cal.timeZone = timezone
        
        return cal.dateComponents([.day], from: date) == cal.dateComponents([.day], from: today)
        
    }
}
