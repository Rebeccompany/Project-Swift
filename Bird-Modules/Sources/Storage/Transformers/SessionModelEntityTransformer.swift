//
//  SessionModelEntityTransformer.swift
//  
//
//  Created by Nathalia do Valle Papst on 03/10/22.
//

import Foundation
import CoreData
import Models

struct SessionModelEntityTransformer: ModelEntityTransformer {
    func requestForAll() -> NSFetchRequest<SessionEntity> {
        SessionEntity.fetchRequest()
    }
    
    func listenerRequest() -> NSFetchRequest<SessionEntity> {
        SessionEntity.fetchRequest()
    }
    
    func modelToEntity(_ model: Session, on context: NSManagedObjectContext) -> SessionEntity {
        let session = SessionEntity(context: context)
        session.date = model.date
        session.id = model.id
        return session
    }
    
    func entityToModel(_ entity: SessionEntity) -> Session? {
        guard
            let date = entity.date,
            let id = entity.id,
            let cards = entity.cards?.allObjects as? [CardEntity],
            let deck = entity.deck?.id
        else { return nil }
        
        let cardsIds = cards.compactMap(\.id)
        
        return Session(
                        cardIds: cardsIds,
                        date: date,
                        deckId: deck,
                        id: id
        )
    }
}
