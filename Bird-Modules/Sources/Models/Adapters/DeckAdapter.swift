//
//  DeckAdapter.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Foundation
import SwiftUI
import Utils

public enum DeckAdapter {
    public static func adapt(_ deck: Deck) -> ExternalDeck {
        ExternalDeck(
            id: deck.storeId,
            name: deck.name,
            description: deck.description,
            icon: IconNames(rawValue: deck.icon) ?? .brain,
            color: deck.color,
            category: deck.category
        )
    }
    
    public static func adapt(_ deck: Deck, with cards: [Card]) -> DeckDTO {
        DeckDTO(
            id: nil,
            name: deck.name,
            description: "",
            icon: IconNames(rawValue: deck.icon) ?? .brain,
            color: deck.color,
            category: deck.category,
            cards: cards.compactMap(CardAdapter.adapt)
        )
    }
    
    public static func adapt(_ dto: DeckDTO) -> (deck: Deck, cards: [Card]) {
        let deck = Deck(
            id: UUID(),
            name: dto.name,
            icon: dto.icon.rawValue,
            color: dto.color,
            collectionId: nil,
            cardsIds: [],
            category: dto.category,
            storeId: dto.id,
            description: dto.description
        )
        
        let cards = dto.cards.compactMap { card -> Card? in
            guard
                let front = card.front.data(using: .utf8)?.toRtf(),
                let back = card.back.data(using: .utf8)?.toRtf()
            else { return nil }
            
            return Card(
                id: UUID(),
                front: front,
                back: back,
                color: card.color,
                datesLogs: DateLogs(),
                deckID: deck.id,
                woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                history: [])
        }
        
        return (deck: deck, cards: cards)
    }
}
