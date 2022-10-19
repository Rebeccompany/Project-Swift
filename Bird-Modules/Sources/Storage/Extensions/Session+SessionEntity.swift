//
//  Session+SessionEntity.swift
//  
//
//  Created by Nathalia do Valle Papst on 06/10/22.
//

import Foundation
import Models
import CoreData

extension Session {
    init?(entity: SessionEntity) {
        guard
            let date = entity.date,
            let id = entity.id,
            let cards = entity.cards?.allObjects as? [CardEntity],
            let deck = entity.deck?.id
        else { return nil }
        
        let cardsIds = cards.compactMap(\.id)
        
        self.init(cardIds: cardsIds, date: date, deckId: deck, id: id)
    }
}
