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
    public let cards: [CardDTO]
}

public struct CardDTO: Codable {
    public let front: String
    public let back: String
    public let color: CollectionColor
}
