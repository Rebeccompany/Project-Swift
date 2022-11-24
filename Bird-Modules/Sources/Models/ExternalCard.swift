//
//  ExernalCard.swift
//  
//
//  Created by Rebecca Mello on 31/10/22.
//

import Foundation

public struct ExternalCard: Identifiable, Codable, Equatable {
    public let id: String
    public let front, back: String
    public let color: CollectionColor
    public let deckId: String
    
    public init(id: String, front: String, back: String, color: CollectionColor, deckId: String) {
        self.id = id
        self.front = front
        self.back = back
        self.color = color
        self.deckId = deckId
    }
}
