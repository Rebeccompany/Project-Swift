//
//  ExternalDeck.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation

public struct ExternalDeck: Identifiable, Codable, Equatable, Hashable {
    
    public let id: String?
    public let name: String
    public let description: String
    public let icon: IconNames
    public let color: CollectionColor
    public let category: DeckCategory
    public let ownerId: String
    public let ownerName: String
    public let cardCount: Int
    
    public init(id: String?, name: String, description: String, icon: IconNames, color: CollectionColor, category: DeckCategory, ownerId: String, ownerName: String, cardCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.color = color
        self.category = category
        self.ownerId = ownerId
        self.ownerName = ownerName
        self.cardCount = cardCount
    }
}
