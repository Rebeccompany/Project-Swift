//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import CoreData
import Models

struct DeckModelEntityTransformer: ModelEntityTransformer {
    let collectionIds: UUID?
    
    init(collectionIds: UUID? = nil) {
        self.collectionIds = collectionIds
    }
    
    func requestForAll() -> NSFetchRequest<DeckEntity> {
        let request = DeckEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DeckEntity.name, ascending: true)]
        return request
    }
    
    func listenerRequest() -> NSFetchRequest<DeckEntity> {
        if let collectionIds = collectionIds {
            let request = requestForAll()
            request.predicate = NSPredicate(format: "%@ IN collections", collectionIds as NSUUID)
            return request
        } else {
            return requestForAll()
        }
    }
    
    func entityToModel(_ entity: DeckEntity) -> Deck? {
        guard
            let id = entity.id,
            let name = entity.name,
            let icon = entity.icon,
            let color = CollectionColor(rawValue: Int(entity.color)),
            let lastAccess = entity.lastAccess,
            let createdAt = entity.createdAt,
            let lastEdit = entity.lastEdit,
            let collections = entity.collections?.allObjects as? [CollectionEntity],
            let cards = entity.cards?.allObjects as? [CardEntity]
        else { return nil }
        
        let maxLearningCards = entity.maxLearningCards
        let maxReviewingCards = entity.maxReviewingCards
        let spacedRepetitionConfig = SpacedRepetitionConfig(maxLearningCards: Int(maxLearningCards), maxReviewingCards: Int(maxReviewingCards))
        let dateLogs = DateLogs(lastAccess: lastAccess, lastEdit: lastEdit, createdAt: createdAt)
        let collectionsIds = collections.compactMap(\.id)
        let cardsIds = cards.compactMap(\.id)
        
        return Deck(
                    id: id,
                    name: name,
                    icon: icon,
                    color: color,
                    datesLogs: dateLogs,
                    collectionsIds: collectionsIds,
                    cardsIds: cardsIds,
                    spacedRepetitionConfig: spacedRepetitionConfig
        )
    }
    
    func modelToEntity(_ model: Deck, on context: NSManagedObjectContext) -> DeckEntity {
        let deck = DeckEntity(context: context)
        deck.createdAt = model.datesLogs.createdAt
        deck.icon = model.icon
        deck.id = model.id
        deck.lastAccess = model.datesLogs.lastAccess
        deck.lastEdit = model.datesLogs.lastEdit
        deck.name = model.name
        deck.maxLearningCards = Int32(model.spacedRepetitionConfig.maxLearningCards)
        deck.maxReviewingCards = Int32(model.spacedRepetitionConfig.maxReviewingCards)
        return deck
    }
}
