//
//  DeckViewModel.swift
//  
//
//  Created by Caroline Taus on 13/09/22.
//

import Foundation
import Models
import HummingBird
import Storage

public class DeckViewModel: ObservableObject {
    @Published var deck: Deck
    @Published var searchFieldContent: String
    @Published var cards: [Card]
    
    private var deckRepository: DeckRepositoryProtocol
    
    public init(deck: Deck, deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil)) {
        self.deck = deck
        self.searchFieldContent = ""
        self.deckRepository = deckRepository
        self.cards = [DeckView_Previews.dummy, DeckView_Previews.dummy, DeckView_Previews.dummy, DeckView_Previews.dummy, DeckView_Previews.dummy]
    }
    
    func searchResults(searchingText: String) -> [Card] {
        var results: [Card] {
            if searchingText.isEmpty {
                return []
            }
            
            else {
                return cards.filter{$0.front.contains(searchingText)}
            }
        }
        
        
    }
}
