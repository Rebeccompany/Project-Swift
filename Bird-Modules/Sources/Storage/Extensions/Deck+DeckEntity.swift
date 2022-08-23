//
//  Deck+DeckEntity.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Models
import CoreData

extension Deck {
    init?(entity: DeckEntity) {
        guard
            let id = entity.id,
            let name = entity.name,
            let icon = entity.icon,
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
        
        self.init(id: id, name: name, icon: icon, datesLogs: dateLogs, collectionsIds: collectionsIds, cardsIds: cardsIds, spacedRepetitionConfig: spacedRepetitionConfig)
    }
}

extension DeckEntity {
    convenience init(withData deck: Deck, on context: NSManagedObjectContext) {
        self.init(context: context)
        self.createdAt = deck.datesLogs.createdAt
        self.icon = deck.icon
        self.id = deck.id
        self.lastAccess = deck.datesLogs.lastAccess
        self.lastEdit = deck.datesLogs.lastEdit
        self.name = deck.name
        self.maxLearningCards = Int32(deck.spacedRepetitionConfig.maxLearningCards)
        self.maxReviewingCards = Int32(deck.spacedRepetitionConfig.maxReviewingCards)
    }
}
