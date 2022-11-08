//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Foundation

enum DeckToExternalDeckAdapter {
    static func adapt(_ deck: Deck) -> ExternalDeck {
        ExternalDeck(
            id: nil,
            name: deck.name,
            description: "",
            icon: IconNames(rawValue: deck.icon) ?? .brain,
            color: deck.color,
            category: deck.category
        )
    }
}
