//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Models
import CoreData

extension DeckEntity {
    convenience init(withData deck: Deck, on context: NSManagedObjectContext) {
        self.init(context: context)
        /**
         @NSManaged public var createdAt: Date?
         @NSManaged public var icon: String?
         @NSManaged public var id: UUID?
         @NSManaged public var lastAccess: Date?
         @NSManaged public var lastEdit: Date?
         @NSManaged public var name: String?
         @NSManaged public var cards: NSSet?
         @NSManaged public var collections: NSSet?
         @NSManaged public var spacedRepetitionConfigs: NSOrderedSet?
         */
        self.createdAt = deck.datesLogs.createdAt
        self.icon = String(deck.icon)
        self.id = deck.id
        self.lastAccess = deck.datesLogs.lastAccess
        self.name = deck.name
    }
}
