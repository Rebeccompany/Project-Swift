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

public class DeckViewModel: ObservableObject {
    @Published var deck: Deck
    @Published var searchFieldContent: String
    @Published var cards: [Card]
    
    private var deckRepository: DeckRepositoryProtocol
    var canStudy: Bool {
        let canStudy = try? checkIfCanStudy()
        return canStudy ?? false
    }
    
    public init(deck: Deck, deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil)) {
        self.deck = deck
        self.searchFieldContent = ""
        self.deckRepository = deckRepository
        self.cards = []
        
    }
    
    func startup() {
        deckRepository.fetchCardsByIds(deck.cardsIds)
            .replaceError(with: [])
            .assign(to: &$cards)
        
    }
    
    private func checkIfCanStudy() throws -> Bool {
        let cardsToStudy = try Woodpecker.wpScheduler(cardsInfo: cards.map{SchedulerCardInfo.init (cardId: $0.id, woodpeckerCardInfo: $0.woodpeckerCardInfo, dueDate: $0.dueDate)}, config: deck.spacedRepetitionConfig)
        
        if (cardsToStudy.todayCards.count > 0) {
            return true
        } else {
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
}
