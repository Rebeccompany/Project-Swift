//
//  CollectionRepositoryProtocol.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Foundation
import Combine
import Models

public protocol CollectionRepositoryProtocol: RepositoryProtocol where T == DeckCollection {
    func addDeck(_ deck: Deck, in collection: DeckCollection) -> AnyPublisher<Void, RepositoryError>
}

public final class CollectionRepository: CollectionRepositoryProtocol {
    
    private var dataStorage: DataStorage
    
    init(_ storage: DataStorage) {
        self.dataStorage = storage
    }
    
    
    public func addDeck(_ deck: Deck, in collection: DeckCollection) -> AnyPublisher<Void, RepositoryError> {
        Future<Void, RepositoryError> {[weak self] promise in
            guard let self = self else {
                promise(.failure(RepositoryError.internalError))
                return
            }
            let entity = CollectionEntity(withData: collection, on: self.dataStorage.mainContext)
            
            
        }
        .eraseToAnyPublisher()
    }
    
    public func listener() -> AnyPublisher<[DeckCollection], RepositoryError> {
        fatalError("Not implemented")
    }
    
    public func fetchAll() -> AnyPublisher<[DeckCollection], RepositoryError> {
        fatalError("Not implemented")
    }
    
    public func fetchById() -> AnyPublisher<DeckCollection, RepositoryError> {
        fatalError("Not implemented")
    }
    
    public func create(_ value: DeckCollection) -> AnyPublisher<Void, RepositoryError> {
        fatalError("Not implemented")
    }
    
    public func edit(_ value: DeckCollection) -> AnyPublisher<Void, RepositoryError> {
        fatalError("Not implemented")
    }
    
    public func delete(_ value: DeckCollection) -> AnyPublisher<Void, RepositoryError> {
        fatalError("Not implemented")
    }
}
