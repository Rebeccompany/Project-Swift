//
//  Session.swift
//  
//
//  Created by Marcos Chevis on 05/09/22.
//

import Foundation

public struct Session: Identifiable, Equatable, Codable, Hashable {

    public var cardIds: [UUID]
    public var date: Date
    public var deckId: UUID
    public var id: UUID
    
    public init(cardIds: [UUID], date: Date, deckId: UUID, id: UUID) {
        self.cardIds = cardIds
        self.date = date
        self.deckId = deckId
        self.id = id
    }
}
