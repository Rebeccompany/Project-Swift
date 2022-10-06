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

extension SessionEntity {
    convenience init(with model: Session, on context: NSManagedObjectContext) throws {
        self.init(context: context)
        self.id = model.id
        self.date = model.date
        
        let deckPredicate = NSPredicate(format: "id == %@", model.deckId as NSUUID)
        let cardsPredicate = NSPredicate(format: "id IN %@", model.cardIds)
        
        let deckRequest = DeckEntity.fetchRequest()
        deckRequest.predicate = deckPredicate
        deckRequest.fetchLimit = 1
        
        let deckEntity = try context.fetch(deckRequest)
        self.deck = deckEntity.first
        
        let cardsRequest = CardEntity.fetchRequest()
        cardsRequest.predicate = cardsPredicate
        
        let cardEntities = try context.fetch(cardsRequest)
        
        cardEntities.forEach { card in
            self.addToCards(card)
        }
    }
}
