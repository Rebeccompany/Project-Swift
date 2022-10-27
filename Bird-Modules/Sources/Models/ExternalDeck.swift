//
//  ExternalDeck.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation

public struct ExternalDeck: Identifiable, Codable, Equatable {
    public init(id: String, name: String, description: String, icon: IconNames, color: CollectionColor, category: DeckCategory) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.color = color
        self.category = category
    }
    
    public let id: String
    public let name: String
    public let description: String
    public let icon: IconNames
    public let color: CollectionColor
    public let category: DeckCategory
}
