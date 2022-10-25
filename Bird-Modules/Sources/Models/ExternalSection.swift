//
//  ExternalSection.swift
//  
//
//  Created by Rebecca Mello on 25/10/22.
//

import Foundation

public struct ExternalSection: Codable, Identifiable, Equatable {
    public var id: String {
        title
    }
    public let title: String
    public let decks: [ExternalDeck]
    
    public init(title: String, decks: [ExternalDeck]) {
        self.title = title
        self.decks = decks
    }
}
