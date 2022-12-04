//
//  DeckDTO.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 09/11/22.
//

import Foundation

public struct DeckDTO: Codable {
    public let id: String?
    public let name: String
    public let description: String
    public let icon: IconNames
    public let color: CollectionColor
    public let category: DeckCategory
    public let ownerId: String
    public let ownerName: String
    public let cards: [CardDTO]
    
    public init(
        id: String?,
        name: String,
        description: String,
        icon: IconNames,
        color: CollectionColor,
        category: DeckCategory,
        ownerId: String,
        ownerName: String,
        cards: [CardDTO]) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.color = color
        self.category = category
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.cards = cards
    }
}

public struct CardDTO: Codable {
    public let front: String
    public let back: String
    public let color: CollectionColor
    
    public init(front: String, back: String, color: CollectionColor) {
        self.front = front
        self.back = back
        self.color = color
    }
}
