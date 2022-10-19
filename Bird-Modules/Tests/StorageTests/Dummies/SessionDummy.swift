//
//  SessionDummy.swift
//  
//
//  Created by Nathalia do Valle Papst on 05/10/22.
//

import Foundation
import Models

enum SessionDummy {
    static var dummy: Session {
        let cardsIds = [CardDummy.dummy.id]
        let date = Date(timeIntervalSince1970: 378297)
        let deckId = UUID(uuidString: "1bdcc8a0-467e-4dd2-b02a-5cce07997a0c")!
        let id = UUID(uuidString: "1b261d9e-ecdf-46f4-9dbf-bcd6f123466e")!
        
        return Session(cardIds: cardsIds, date: date, deckId: deckId, id: id)
    }
    
    static func newDummySession(id: UUID, date: Date) -> Session {
        let cardsIds = [CardDummy.dummy.id]
        let deckId = UUID(uuidString: "1bdcc8a0-467e-4dd2-b02a-5cce07997a0c")!
        let date = date
        let id = id
        
        return Session(cardIds: cardsIds, date: date, deckId: deckId, id: id)
    }
}
