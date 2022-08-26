//
//  DeckCollection+CollectionEntity.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Foundation
import Models
import CoreData

extension DeckCollection {
    init?(entity: CollectionEntity) {
        guard
            let id = entity.id,
            let name = entity.name,
            let iconPath = entity.iconPath,
            let lastAccess = entity.lastAccess,
            let createdAt = entity.createdAt,
            let lastEdit = entity.lastEdit,
            let decks = entity.decks?.array as? [DeckEntity]
        else { return nil }
        
        let decksIds = decks.compactMap(\.id)
        let dateLogs = DateLogs(lastAccess: lastAccess, lastEdit: lastEdit, createdAt: createdAt)
        
        self.init(id: id, name: name, iconPath: iconPath, datesLogs: dateLogs, decksIds: decksIds)
    }
}

extension CollectionEntity {
    convenience init(with collection: DeckCollection, on context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = collection.id
        self.name = collection.name
        self.iconPath = collection.iconPath
        self.lastEdit = collection.datesLogs.lastEdit
        self.createdAt = collection.datesLogs.createdAt
        self.lastAccess = collection.datesLogs.lastAccess
    }
}
