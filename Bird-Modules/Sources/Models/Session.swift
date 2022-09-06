//
//  File.swift
//  
//
//  Created by Marcos Chevis on 05/09/22.
//

import Foundation

public struct Session {

    public var cardIds: [UUID]
    public var date: Date
    public var deckId: UUID
    
    public init(cardIds: [UUID], date: Date, deckId: UUID) {
        self.cardIds = cardIds
        self.date = date
        self.deckId = deckId
    }
}
