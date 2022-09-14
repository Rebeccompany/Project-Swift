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

public class DeckViewModel: ObservableObject {
    @Published var deck: Deck
    @Published var searchFieldContent: String
    @Published var cards: [Card]
    @Published var canStudy: Bool
    
    private var deckRepository: DeckRepositoryProtocol
    
    public init(deck: Deck, deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil)) {
        self.deck = deck
        self.searchFieldContent = ""
        self.deckRepository = deckRepository
        self.cards = []
        self.canStudy = true
    }
    
    func startup() {
        deckRepository.fetchCardsByIds(deck.cardsIds)
            .replaceError(with: [])
            .assign(to: &$cards)
    }
    
    func deleteFlashcard(card: Card) {
        do {
            try deckRepository.deleteCard(card)
        } catch {
            print("erroooo")
        }
    }
    
    var cardsSearched: [Card] {
        if searchFieldContent.isEmpty {
            return cards
        } else {
            return cards.filter { NSAttributedString($0.front).string.contains(searchFieldContent) || NSAttributedString($0.back).string.contains(searchFieldContent) }
        }
    }
}
