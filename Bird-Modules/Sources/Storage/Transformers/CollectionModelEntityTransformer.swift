//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import Models
import CoreData

struct CollectionModelEntityTransformer: ModelEntityTransformer {
    func requestForAll() -> NSFetchRequest<CollectionEntity> {
        let request = CollectionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)]
        return request
    }
    
    func listenerRequest() -> NSFetchRequest<CollectionEntity> {
        requestForAll()
    }
    
    func modelToEntity(_ model: DeckCollection, on context: NSManagedObjectContext) -> CollectionEntity {
        let collection = CollectionEntity(context: context)
        collection.id = model.id
        collection.name = model.name
        collection.icon = model.icon.rawValue
        collection.lastEdit = model.datesLogs.lastEdit
        collection.createdAt = model.datesLogs.createdAt
        collection.lastAccess = model.datesLogs.lastAccess
        
        return collection
    }
    
    func entityToModel(_ entity: CollectionEntity) -> DeckCollection? {
        guard
            let id = entity.id,
            let name = entity.name,
            let icon = IconNames(rawValue: entity.icon ?? IconNames.atom.rawValue),
            let lastAccess = entity.lastAccess,
            let createdAt = entity.createdAt,
            let lastEdit = entity.lastEdit,
            let decks = entity.decks?.allObjects as? [DeckEntity]
        else { return nil }
        
        let decksIds = decks.compactMap(\.id)
        let dateLogs = DateLogs(lastAccess: lastAccess, lastEdit: lastEdit, createdAt: createdAt)
        
        return DeckCollection(id: id, name: name, icon: icon, datesLogs: dateLogs, decksIds: decksIds)
    }
}
