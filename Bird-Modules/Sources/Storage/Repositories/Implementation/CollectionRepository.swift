//
//  CollectionRepository.swift
//  
//
//  Created by Marcos Chevis on 29/08/22.
//

import Foundation
import Models
import Combine

class CollectionRepository: CollectionRepositoryProtocol {

    private let collectionRepository: Repository<DeckCollection, CollectionEntity, CollectionModelEntityTransformer>
    private let deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>
    
    init(collectionRepository: Repository<DeckCollection, CollectionEntity, CollectionModelEntityTransformer>,
         deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>) {
        self.collectionRepository = collectionRepository
        self.deckRepository = deckRepository
    }
    
    convenience public init() {
        self.init(collectionRepository: Repository(transformer: CollectionModelEntityTransformer(), .shared),
                  deckRepository: Repository(transformer: DeckModelEntityTransformer(), .shared)
        )
    }
    
    func addDeck(_ deck: Deck, in collection: DeckCollection) throws {
        let collectionEntity = try collectionRepository.fetchEntityById(collection.id)
        let deckEntity = try deckRepository.fetchEntityById(deck.id)
        collectionEntity.addToDecks(deckEntity)
        try collectionRepository.save()
    }
    
    func removeDeck(_ deck: Deck, from collection: DeckCollection) throws {
        let collectionEntity = try collectionRepository.fetchEntityById(collection.id)
        let deckEntity = try deckRepository.fetchEntityById(deck.id)
        collectionEntity.removeFromDecks(deckEntity)
        try collectionRepository.save()
    }
    
    func createCollection(_ collection: DeckCollection) throws {
        try collectionRepository.create(collection)
    }
    
    func deleteCollection(_ collection: DeckCollection) throws {
        try collectionRepository.delete(collection)
    }
    
    func editCollection(_ collection: DeckCollection) throws {
        let collectionEntity = try collectionRepository.fetchEntityById(collection.id)
        collectionEntity.lastEdit = collection.datesLogs.lastEdit
        collectionEntity.lastAccess = collection.datesLogs.lastAccess
        collectionEntity.name = collection.name
        collectionEntity.iconPath = collection.iconPath
        try collectionRepository.save()
    }
    
    func listener() -> AnyPublisher<[DeckCollection], RepositoryError> {
        do {
            let listener = try collectionRepository.listener()
            return listener
        } catch {
            return Fail<[DeckCollection], RepositoryError>(error: .errorOnListening)
                .eraseToAnyPublisher()
        }
        
    }
    
    
}
