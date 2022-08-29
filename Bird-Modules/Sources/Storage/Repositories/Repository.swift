//
//  Repository.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Foundation
import Combine
import CoreData
import Models

final class Repository<Model: Identifiable, Entity, Transformer: ModelEntityTransformer>: NSObject, NSFetchedResultsControllerDelegate where Transformer.Entity == Entity, Transformer.Model == Model, Model.ID == UUID {
    
    private let transformer: Transformer
    //MARK: CoreData Objects
    private let dataStorage: DataStorage
    private let requestController: NSFetchedResultsController<Entity>
    private let listenerRequest: NSFetchRequest<Entity>
    
    //MARK: Subjects
    private let listenerSubject: CurrentValueSubject<[Model], RepositoryError>
    
    init(transformer: Transformer, _ storage: DataStorage) {
        self.transformer = transformer
        self.listenerRequest = transformer.listenerRequest()
        self.dataStorage = storage
        self.listenerSubject = .init([])
        self.requestController = NSFetchedResultsController(fetchRequest: listenerRequest,
                                                            managedObjectContext: dataStorage.mainContext,
                                                            sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        self.requestController.delegate = self
    }
    
    func fetchAll() -> AnyPublisher<[Model], RepositoryError> {
        singleRequest(listenerRequest)
    }
    
    func listener() throws -> AnyPublisher<[Model], RepositoryError> {
        do {
            try requestController.performFetch()
            
            guard let objects = requestController.fetchedObjects else {
                throw RepositoryError.failedFetching
            }
            
            let mappedObjects = objects.compactMap(transformer.entityToModel(_:))
            listenerSubject.value = mappedObjects
            return listenerSubject.eraseToAnyPublisher()
        } catch {
            print("func listener()", error)
            throw RepositoryError.errorOnListening
        }
    }
    
    func fetchById(_ id: UUID) -> AnyPublisher<Model, RepositoryError> {
        let fetchRequest = transformer.requestForAll()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        do {
            let data = try dataStorage.mainContext.fetch(fetchRequest)
            
            guard let first = data.first,
                  let mappedData = transformer.entityToModel(first)
            else {
                return Fail<Model, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
            }
            
            return Just(mappedData).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } catch {
            print("func fetchById", error)
            return Fail<Model, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
        }
    }
    
    func fetchMultipleById(_ ids: [UUID]) -> AnyPublisher<[Model], RepositoryError> {
        let fetchRequest = transformer.requestForAll()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        return singleRequest(fetchRequest)
    }
    
    @discardableResult
    func create(_ value: Model) throws -> Entity {
        let entity = transformer.modelToEntity(value, on: dataStorage.mainContext)
        
        do {
            try dataStorage.save()
            return entity
        } catch {
            print("func create", error)
            throw RepositoryError.couldNotCreate
        }
    }
//    
//        func edit(_ value: Model) throws {
//            fatalError()
//        }
    
    func delete(_ value: Model) throws {
        let entity = try fetchEntityById(value.id)
        
        dataStorage.mainContext.delete(entity)
        
        try dataStorage.save()
    }
    
    private func singleRequest(_ request: NSFetchRequest<Entity>) -> AnyPublisher<[Model], RepositoryError> {
        do {
            let data = try dataStorage.mainContext.fetch(request)
            let mappedData = data.compactMap(transformer.entityToModel(_:))
            return Just(mappedData).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } catch {
            print("func singleRequest()", error)
            return Fail<[Model],RepositoryError>(error: RepositoryError.failedFetching).eraseToAnyPublisher()
        }
    }
    
    func fetchEntityById(_ id: UUID) throws -> Entity {
        let fetchRequest = transformer.requestForAll()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        let data = try dataStorage.mainContext.fetch(fetchRequest)
        
        guard let first = data.first
        else {
            throw RepositoryError.failedFetching
        }
        
        return first
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let data = controller.fetchedObjects as? [Entity] else { return }
        
        do {
            try dataStorage.mainContext.obtainPermanentIDs(for: data)
            let modelData = data.compactMap(transformer.entityToModel(_:))
            listenerSubject.send(modelData)
        } catch {
            listenerSubject.send(completion: .failure(.errorOnListening))
        }
    }
    
    func save() throws {
        try dataStorage.save()
    }
}



public enum RepositoryError: Error {
    case failedFetching
    case errorOnListening
    case notFound
    case couldNotEdit
    case couldNotDelete
    case internalError
    case couldNotCreate
}
