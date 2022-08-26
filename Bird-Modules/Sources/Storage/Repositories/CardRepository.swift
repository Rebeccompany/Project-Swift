//
//  CardRepository.swift
//  
//
//  Created by Marcos Chevis on 26/08/22.
//

import Foundation
import Combine
import Models
import CoreData

public protocol CardRepositoryProtocol: RepositoryProtocol where T == Card {
    func addToHistory(_ snapshot: CardSnapshot, in card: Card) throws
}

public final class CardRepository: NSObject, CardRepositoryProtocol {

    // MARK: CoreData Objects
    private let dataStorage: DataStorage
    private let requestController: NSFetchedResultsController<CardEntity>
    private let listenerRequest: NSFetchRequest<CardEntity> = {
        let request = CardEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardEntity.wpStep, ascending: true)]
        return request
    }()
    
    // MARK: Subjects
    private let listenerSubject: CurrentValueSubject<[Card], RepositoryError>
    
    init(_ storage: DataStorage) {
        self.dataStorage = storage
        self.listenerSubject = .init([])
        self.requestController = NSFetchedResultsController(fetchRequest: listenerRequest,
                                                            managedObjectContext: dataStorage.mainContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        super.init()
        
        self.requestController.delegate = self
    }
    
    // MARK: Repository Features
    public func listener() throws -> AnyPublisher<[Card], RepositoryError> {
        do {
            try requestController.performFetch()
            
            guard let objects = requestController.fetchedObjects else {
                throw RepositoryError.failedFetching
            }
            
            let mappedObjects = objects.compactMap(Card.init(entity:))
            listenerSubject.value = mappedObjects
            return listenerSubject.eraseToAnyPublisher()
        } catch {
            throw RepositoryError.errorOnListening
        }
    }
    
    public func fetchAll() -> AnyPublisher<[Card], RepositoryError> {
        singleRequest(listenerRequest)
    }
    
    public func fetchMultipleById(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError> {
        let fetchRequest = CardEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CardEntity.wpStep, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
        
        return singleRequest(fetchRequest)
    }
    
    private func singleRequest(_ request: NSFetchRequest<CardEntity>) -> AnyPublisher<[Card], RepositoryError> {
        do {
            let data = try dataStorage.mainContext.fetch(request)
            let mappedData = data.compactMap(Card.init(entity:))
            return Just(mappedData).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } catch {
            return Fail<[Card], RepositoryError>(error: RepositoryError.failedFetching).eraseToAnyPublisher()
        }
    }
    
    public func fetchById(_ id: UUID) -> AnyPublisher<Card, RepositoryError> {
        let fetchRequest = CardEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CardEntity.wpStep, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        do {
            let data = try dataStorage.mainContext.fetch(fetchRequest)
            
            guard let first = data.first,
                  let mappedData = Card(entity: first)
            else {
                return Fail<Card, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
            }
            
            return Just(mappedData).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } catch {
            return Fail<Card, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
        }
    }
    
    private func fetchEntityById(_ id: UUID) throws -> CardEntity {
        let fetchRequest = CardEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CardEntity.wpStep, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        let data = try dataStorage.mainContext.fetch(fetchRequest)
        
        guard let first = data.first
        else {
            throw RepositoryError.failedFetching
        }
        
        return first
    }
    
    public func create(_ value: Card) throws {
        let _ = CardEntity(with: value, on: dataStorage.mainContext)
        
        
        do {
            try dataStorage.save()
        } catch {
            throw RepositoryError.couldNotCreate
        }
    
    }
    
    public func edit(_ value: Card) throws {
        let entity = try fetchEntityById(value.id)
        
        entity.lastAccess = value.datesLogs.lastAccess
        entity.lastEdit = value.datesLogs.lastEdit
        entity.wpEaseFactor = value.woodpeckerCardInfo.easeFactor
        entity.wpInterval = Int32(value.woodpeckerCardInfo.interval)
        entity.wpIsGraduated = value.woodpeckerCardInfo.isGraduated
        entity.wpStep = Int32(value.woodpeckerCardInfo.step)
        entity.wpStreak = Int32(value.woodpeckerCardInfo.streak)
        
        let nsAtributtedFront = NSAttributedString(value.front)
        if let frontData = nsAtributtedFront.rftData() {
            entity.front = frontData
        }
        
        let nsAtributtedBack = NSAttributedString(value.back)
        if let backData = nsAtributtedBack.rftData() {
            entity.back = backData
        }
        
    }
    
    public func delete(_ value: Card) throws {
        let entity = try fetchEntityById(value.id)
        dataStorage.mainContext.delete(entity)
        try dataStorage.save()
    }
    
    // MARK: Card specific features
    public func addToHistory(_ snapshot: CardSnapshot, in card: Card) throws {
        let cardEntity = try fetchEntityById(card.id)
        
        let historyEntity = CardSnapshotEntity(with: snapshot, on: dataStorage.mainContext)
        
        cardEntity.addToHistory(historyEntity)
        try dataStorage.save()
        
    }
    
}

extension CardRepository: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let data = controller.fetchedObjects as? [CardEntity] else { return }
        
        do {
            try dataStorage.mainContext.obtainPermanentIDs(for: data)
            let modelData = data.compactMap(Card.init(entity:))
            listenerSubject.send(modelData)
        } catch {
            listenerSubject.send(completion: .failure(.errorOnListening))
        }
    }
}
