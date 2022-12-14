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
            let cards = entity.cards?.allObjects as? [CardEntity],
            let rawCategory = entity.category,
            let category = DeckCategory(rawValue: rawCategory)
        else { return nil }
        let collection = entity.collection
        
        let maxLearningCards = entity.maxLearningCards
        let maxReviewingCards = entity.maxReviewingCards
        let spacedRepetitionConfig = SpacedRepetitionConfig(maxLearningCards: Int(maxLearningCards), maxReviewingCards: Int(maxReviewingCards), numberOfSteps: Int(entity.numberOfSteps))
        let dateLogs = DateLogs(lastAccess: lastAccess, lastEdit: lastEdit, createdAt: createdAt)
        let collectionIds = collection?.id
        let cardsIds = cards.compactMap(\.id)
        let session: Session?
        
        if let sessionEntity = entity.session {
            session = Session(entity: sessionEntity)
        } else {
            session = nil
        }
        
        return Deck(
                    id: id,
                    name: name,
                    icon: icon,
                    color: color,
                    datesLogs: dateLogs,
                    collectionId: collectionIds,
                    cardsIds: cardsIds,
                    spacedRepetitionConfig: spacedRepetitionConfig,
                    session: session,
                    category: category,
                    storeId: entity.storeId,
                    description: entity.deckDescription ?? "",
                    ownerId: entity.ownerId
        )
    }
    
    func modelToEntity(_ model: Deck, on context: NSManagedObjectContext) -> DeckEntity {
        let deck = DeckEntity(context: context)
        deck.createdAt = model.datesLogs.createdAt
        deck.icon = model.icon
        deck.color = Int16(model.color.rawValue)
        deck.id = model.id
        deck.lastAccess = model.datesLogs.lastAccess
        deck.lastEdit = model.datesLogs.lastEdit
        deck.name = model.name
        deck.maxLearningCards = Int32(model.spacedRepetitionConfig.maxLearningCards)
        deck.maxReviewingCards = Int32(model.spacedRepetitionConfig.maxReviewingCards)
        deck.numberOfSteps = Int16(model.spacedRepetitionConfig.numberOfSteps)
        deck.category = model.category.rawValue
        deck.storeId = model.storeId
        deck.deckDescription = model.description
        deck.ownerId = model.ownerId
        return deck
    }
}
