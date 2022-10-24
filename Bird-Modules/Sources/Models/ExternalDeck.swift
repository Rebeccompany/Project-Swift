//
//  ExternalDeck.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation

public struct ExternalDeck: Identifiable, Codable {
    public let id: String
    let name: String
    let description: String
    let icon: IconNames
    let color: CollectionColor
    let category: DeckCategory
}
