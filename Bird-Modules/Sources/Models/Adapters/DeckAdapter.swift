//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Foundation

public enum DeckAdapter {
    public static func adapt(_ deck: Deck) -> ExternalDeck {
        ExternalDeck(
            id: deck.storeId,
            name: deck.name,
            description: "",
            icon: IconNames(rawValue: deck.icon) ?? .brain,
            color: deck.color,
            category: deck.category
        )
    }
    
    public static func adapt(_ deck: Deck, with cards: [Card]) -> DeckDTO {
        return DeckDTO(
            name: deck.name,
            description: "",
            icon: IconNames(rawValue: deck.icon) ?? .brain,
            color: deck.color,
            category: deck.category,
            cards: cards.compactMap(CardAdapter.adapt)
        )
    }
}
