//
//  DeckViewModel.swift
//  
//
//  Created by Caroline Taus on 13/09/22.
//

import Foundation
import Models
import HummingBird
import Combine
import Storage
import Woodpecker
import Utils

public class DeckViewModel: ObservableObject {
    @Published var searchFieldContent: String
    @Published var cards: [Card]
    @Published var editingFlashcard: Card?
    
    private var deckRepository: DeckRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private var dateHandler: DateHandlerProtocol
    private var sessionCacher: SessionCacher
    
   
    
    public init(deck: Deck, deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil), dateHandler: DateHandlerProtocol = DateHandler(), sessionCacher: SessionCacher = SessionCacher()) {
        self.searchFieldContent = ""
        self.deckRepository = deckRepository
        self.cards = []
        self.dateHandler = dateHandler
        self.sessionCacher = sessionCacher
    }
    
    private func cardListener(_ deck: Deck) -> AnyPublisher<[Card], Never> {
        deckRepository
            .cardListener(forId: deck.id)
            .replaceError(with: [])
            .map { cards in cards.sorted { c1, c2 in c1.datesLogs.createdAt > c2.datesLogs.createdAt } }
            .eraseToAnyPublisher()
    }
    
    private func deckListener(_ deck: Deck) -> AnyPublisher<Deck, RepositoryError> {
        deckRepository
            .cardListener(forId: deck.id)
            .flatMap {[weak self, deck] _ in
                guard let self = self else {
                    return Fail<Deck, RepositoryError>(error: .errorOnListening).eraseToAnyPublisher()
                }
                
                return self.deckRepository.fetchDeckById(deck.id)
            }
            .eraseToAnyPublisher()
    }
    
    func startup(_ deck: Deck) {
        cardListener(deck)
            .assign(to: &$cards)
        
        deckListener(deck)
            .sink { _ in
                
            } receiveValue: {[weak self] deck in
            }
            .store(in: &cancellables)
    }
    
    func checkIfCanStudy(_ deck: Deck) -> Bool {
        
        do {
            if let session = sessionCacher.currentSession(for: deck.id), dateHandler.isToday(date: session.date) {
                return !session.cardIds.isEmpty
            }
            
            let cardsInfo = cards.map { OrganizerCardInfo(card: $0) }
            let cardsToStudy = try Woodpecker.scheduler(cardsInfo: cardsInfo, config: deck.spacedRepetitionConfig)
            let todayCards = cardsToStudy.todayLearningCards + cardsToStudy.todayReviewingCards
            if !todayCards.isEmpty {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
        
    }
    
    func deleteFlashcard(card: Card) throws {
        try deckRepository.deleteCard(card)
    }
    
    var cardsSearched: [Card] {
        if searchFieldContent.isEmpty {
            return cards
        } else {
            return cards.filter { NSAttributedString($0.front).string.contains(searchFieldContent) || NSAttributedString($0.back).string.contains(searchFieldContent) }
        }
    }
    
    func editFlashcard(_ card: Card) {
        editingFlashcard = card
    }
    
    func createFlashcard() {
        editingFlashcard = nil
    }
}
