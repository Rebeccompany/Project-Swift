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
    private let repository: Repository<DeckCollection, CollectionEntity, CollectionModelEntityTransformer>
    
    init(repository: Repository<DeckCollection, CollectionEntity, CollectionModelEntityTransformer>) {
        self.repository = repository
    }
    
    convenience public init() {
        self.init(repository: Repository(transformer: CollectionModelEntityTransformer(), .shared))
    }
    
    func addDeck(_ deck: Deck, in collection: DeckCollection) throws {
        
    }
    
    func removeDeck(_ deck: Deck, from collection: DeckCollection) throws {
        
    }
    
    func createCollection(_ collection: DeckCollection) throws {
        try repository.create(collection)
    }
    
    func listener() -> AnyPublisher<[DeckCollection], RepositoryError> {
        do {
            let listener = try repository.listener()
            return listener
        } catch {
            return Fail<[DeckCollection], RepositoryError>(error: .errorOnListening)
                .eraseToAnyPublisher()
        }
        
    }
    
    
}
