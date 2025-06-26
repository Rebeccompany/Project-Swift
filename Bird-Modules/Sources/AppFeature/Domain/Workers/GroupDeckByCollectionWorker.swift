//
//  GroupDeckByCollectionWorker.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 25/06/25.
//

import Utils
import Models
import Foundation
import Habitat

struct GroupDeckByCollectionInput {
    let decks: [Deck]
    let collections: [DeckCollection]
}

struct GroupDeckByCollectionWorker: SyncWorker {
    init() {}
    
    func execute(_ input: GroupDeckByCollectionInput) throws -> [String: [Deck]] {
        Dictionary(grouping: input.decks) { deck in
            if let collectionId = deck.collectionId {
                return input.collections.first { collection in
                    collection.id == collectionId
                }?.name ?? NSLocalizedString("sem_coleção", bundle: .module, comment: "Sem coleção")
            } else {
                return NSLocalizedString("sem_coleção", bundle: .module, comment: "Sem coleção")
            }
        }
    }
}
