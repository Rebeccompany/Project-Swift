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
import Habitat

@MainActor
public class DeckViewModel: ObservableObject {
    @Published var searchFieldContent: String
    @Published var cards: [Card]
    
    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    
    public init() {
        self.searchFieldContent = ""
        self.cards = []
    }
    
    private func cardListener(_ deck: Deck) -> AnyPublisher<[Card], Never> {
        deckRepository
            .cardListener(forId: deck.id)
            .replaceError(with: [])
            .map { cards in cards.sorted { c1, c2 in c1.datesLogs.createdAt > c2.datesLogs.createdAt } }
            .eraseToAnyPublisher()
    }
    
    func startup(_ deck: Deck) {
        cardListener(deck)
            .sink { [weak self] cards in self?.cards = cards }
            .store(in: &cancellables)
        
        var deck = deck
        deck.datesLogs.lastAccess = dateHandler.today
        try? deckRepository.editDeck(deck)
    }
    
    func tearDown() {
        cancellables
            .forEach { $0.cancel() }
    }
    
    func checkIfCanStudy(_ deck: Deck) -> Bool {
        do {
            if let session = deck.session, let isToday = try? dateHandler.isToday(date: session.date), isToday {
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
            return cards.filter { $0.front.string.contains(searchFieldContent) || $0.back.string.contains(searchFieldContent) }
        }
    }
    
}
