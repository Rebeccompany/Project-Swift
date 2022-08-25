//
//  CollectionRepositoryProtocol.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Foundation
import Combine
import Models
import CoreData

public protocol CollectionRepositoryProtocol: RepositoryProtocol where T == DeckCollection {
    func addDeck(_ deck: Deck, in collection: DeckCollection) throws
}

public final class CollectionRepository: NSObject, CollectionRepositoryProtocol {
    
    //MARK: CoreData Objects
    private let dataStorage: DataStorage
    private let requestController: NSFetchedResultsController<CollectionEntity>
    private let listenerRequest: NSFetchRequest<CollectionEntity> = {
        let request = CollectionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)]
        return request
    }()
    
    //MARK: Subjects
    private let listenerSubject: CurrentValueSubject<[DeckCollection], RepositoryError>
    
    init(_ storage: DataStorage) {
        self.dataStorage = storage
        self.listenerSubject = .init([])
        self.requestController = NSFetchedResultsController(fetchRequest: listenerRequest,
                                                            managedObjectContext: dataStorage.mainContext,
                                                            sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        
        self.requestController.delegate = self
    }
    
    //MARK: Repository Features
    public func listener() throws -> AnyPublisher<[DeckCollection], RepositoryError> {
        do {
            try requestController.performFetch()
            
            guard let objects = requestController.fetchedObjects else {
                throw RepositoryError.failedFetching
            }
            
            let mappedObjects = objects.compactMap(DeckCollection.init(entity:))
            listenerSubject.value = mappedObjects
            return listenerSubject.eraseToAnyPublisher()
        } catch {
            print("func listener()", error)
            throw RepositoryError.errorOnListening
        }
    }
    
    public func fetchAll() -> AnyPublisher<[DeckCollection], RepositoryError> {
        singleRequest(listenerRequest)
    }
    
    public func fetchMultipleById(_ ids: [UUID]) -> AnyPublisher<[DeckCollection], RepositoryError> {
        let fetchRequest = CollectionEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        
        return singleRequest(fetchRequest)
    }
    
    private func singleRequest(_ request: NSFetchRequest<CollectionEntity>) -> AnyPublisher<[DeckCollection], RepositoryError> {
        do {
            let data = try dataStorage.mainContext.fetch(request)
            let mappedData = data.compactMap(DeckCollection.init(entity:))
            return Just(mappedData).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } catch {
            print("func singleRequest()", error)
            return Fail<[DeckCollection],RepositoryError>(error: RepositoryError.failedFetching).eraseToAnyPublisher()
        }
    }
    
    public func fetchById(_ id: UUID) -> AnyPublisher<DeckCollection, RepositoryError> {
        let fetchRequest = CollectionEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        do {
            let data = try dataStorage.mainContext.fetch(fetchRequest)
            
            guard let first = data.first,
                  let mappedData = DeckCollection(entity: first)
            else {
                return Fail<DeckCollection, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
            }
            
            return Just(mappedData).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } catch {
            print("func fetchById", error)
            return Fail<DeckCollection, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
        }
    }
    
    private func fetchEntityById(_ id: UUID) throws -> CollectionEntity {
        let fetchRequest = CollectionEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        do {
            let data = try dataStorage.mainContext.fetch(fetchRequest)
            
            guard let first = data.first,
                  let mappedData = DeckCollection(entity: first)
            else {
                throw 
            }
            
            return Just(mappedData).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } catch {
            print("func fetchById", error)
            return Fail<DeckCollection, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
        }
    }
    
    public func create(_ value: DeckCollection) throws {
        guard let entity = CollectionEntity(withData: value, on: dataStorage.mainContext)
        else {
            throw RepositoryError.couldNotCreate
        }
        
        do {
            try dataStorage.save()
        } catch {
            print("func create", error)
            throw RepositoryError.couldNotCreate
        }
    
    }
    
    public func edit(_ value: DeckCollection) throws {
        fatalError("Not implemented")
    }
    
    public func delete(_ value: DeckCollection) throws {
        fatalError("Not implemented")
    }
    
    //MARK: Collection especific features
    public func addDeck(_ deck: Deck, in collection: DeckCollection) throws {
        
    }
}

extension CollectionRepository: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let data = controller.fetchedObjects as? [CollectionEntity] else { return }
        
        do {
            try dataStorage.mainContext.obtainPermanentIDs(for: data)
            let modelData = data.compactMap(DeckCollection.init(entity:))
            listenerSubject.send(modelData)
        } catch {
            listenerSubject.send(completion: .failure(.errorOnListening))
        }
    }
}
