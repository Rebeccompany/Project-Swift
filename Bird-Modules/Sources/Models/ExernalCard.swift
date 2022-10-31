//
//  ExernalCard.swift
//  
//
//  Created by Rebecca Mello on 31/10/22.
//

import Foundation

public struct ExernalCard: Identifiable, Codable, Equatable {
    public let id: String
    public let front, back: String
    public let color: CollectionColor
    public let deckId: String
    
}
