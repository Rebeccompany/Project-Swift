//
//  DeckCellInfo.swift
//  
//
//  Created by Nathalia do Valle Papst on 14/09/22.
//

import Foundation
import Models

struct DeckCellInfo {
    var icon: String
    var numberOfCards: Int
    var name: String
    var color: CollectionColor
    
    init(icon: String, numberOfCards: Int, name: String, color: CollectionColor) {
        self.icon = icon
        self.numberOfCards = numberOfCards
        self.name = name
        self.color = color
    }
    
    init(deck: Deck) {
        self.icon = deck.icon
        self.numberOfCards = deck.cardsIds.count
        self.name = deck.name
        self.color = deck.color
    }
}
