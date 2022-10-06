//
//  CollectionRepositoryMock.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/09/22.
//

import Foundation
import Models
import Combine
import Utils

//swiftlint: disable private_subject
public final class CollectionRepositoryMock: CollectionRepositoryProtocol {
    public var shouldThrowError: Bool = false
    var dateHandler = DateHandlerMock()
    
    public static let shared: CollectionRepositoryProtocol = {
        CollectionRepositoryMock()
    }()
    
    public init() {}
    
    public lazy var collections: [DeckCollection] = [
        DeckCollection(id: UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!,
                       name: "Matemática Básica",
                       icon: .atom,
                       datesLogs: DateLogs(
                        lastAccess: dateHandler.today,
                        lastEdit: dateHandler.today,
                        createdAt: dateHandler.today),
                       decksIds: [
                        UUID(uuidString: "a498bc3c-85a3-4784-b560-a33a272a0a92")!,
                        UUID(uuidString: "4e56be0a-bc7c-4497-aec9-c30482e82496")!,
                        UUID(uuidString: "3947217b-2f55-4f16-ae59-10017d291579")!
                       ]
                      ),
        
        DeckCollection(id: UUID(uuidString: "4f298230-4286-4a83-9f1c-53fd60533ed8")!,
                       name: "Portugues",
                       icon: .atom,
                       datesLogs: DateLogs(
                        lastAccess: dateHandler.today,
                        lastEdit: dateHandler.today,
                        createdAt: dateHandler.today),
                       decksIds: [
                        UUID(uuidString: "a498bc3c-85a3-4784-b560-a33a272a0a92")!,
                        UUID(uuidString: "4e56be0a-bc7c-4497-aec9-c30482e82496")!
                       ]
                      ),
        
        DeckCollection(id: UUID(uuidString: "9b06af85-e4e8-442d-be7a-40450cfd310c")!,
                       name: "Programação JAVA",
                       icon: .atom,
                       datesLogs: DateLogs(
                        lastAccess: dateHandler.today,
                        lastEdit: dateHandler.today,
                        createdAt: dateHandler.today),
                       decksIds: [
                        UUID(uuidString: "a498bc3c-85a3-4784-b560-a33a272a0a92")!,
                        UUID(uuidString: "4e56be0a-bc7c-4497-aec9-c30482e82496")!,
                        UUID(uuidString: "3947217b-2f55-4f16-ae59-10017d291579")!
                       ]
                      ),
        
        DeckCollection(id: UUID(uuidString: "855eb618-602e-449d-83fc-5de6b8a36454")!,
                       name: "Geografia",
                       icon: .atom,
                       datesLogs: DateLogs(
                        lastAccess: dateHandler.today,
                        lastEdit: dateHandler.today,
                        createdAt: dateHandler.today),
                       decksIds: [
                        UUID(uuidString: "a498bc3c-85a3-4784-b560-a33a272a0a92")!,
                        UUID(uuidString: "4e56be0a-bc7c-4497-aec9-c30482e82496")!,
                        UUID(uuidString: "3947217b-2f55-4f16-ae59-10017d291579")!
                       ]
                      ),
        
        DeckCollection(id: UUID(uuidString: "5285798a-4107-48b3-8994-e706699a3445")!,
                       name: "Bandeiras",
                       icon: .atom,
                       datesLogs: DateLogs(
                        lastAccess: dateHandler.today,
                        lastEdit: dateHandler.today,
                        createdAt: dateHandler.today),
                       decksIds: [
                        UUID(uuidString: "a498bc3c-85a3-4784-b560-a33a272a0a92")!,
                        UUID(uuidString: "4e56be0a-bc7c-4497-aec9-c30482e82496")!,
                        UUID(uuidString: "3947217b-2f55-4f16-ae59-10017d291579")!
                       ]
                      )
    ]
    
    public lazy var listenerSubject = CurrentValueSubject<[DeckCollection], RepositoryError>(collections)
    
    public func addDeck(_ deck: Deck, in collection: DeckCollection) throws {
        if shouldThrowError {
            throw RepositoryError.couldNotCreate
        }
        guard let collectionIndex = collections.firstIndex(where: { $0.id == collection.id }) else {
            throw RepositoryError.couldNotEdit
        }
        
        var collection = collection
        collection.decksIds.append(deck.id)
        collections[collectionIndex] = collection
        
        listenerSubject.send(collections)
    }
    
    public func removeDeck(_ deck: Deck, from collection: DeckCollection) throws {
        if shouldThrowError {
            throw RepositoryError.couldNotDelete
        }
        guard let collectionIndex = collections.firstIndex(where: { $0.id == collection.id }) else {
            throw RepositoryError.couldNotEdit
        }
        
        var collection = collection
        collection.decksIds = collection.decksIds.filter { $0 != collection.id }
        collections[collectionIndex] = collection
        
        listenerSubject.send(collections)
    }
    
    public func createCollection(_ collection: DeckCollection) throws {
        if shouldThrowError {
            throw RepositoryError.couldNotCreate
        }
        
        collections.append(collection)
        
        listenerSubject.send(collections)
    }
    
    public func deleteCollection(_ collection: DeckCollection) throws {
        if shouldThrowError {
            throw RepositoryError.couldNotDelete
        }
        collections = collections.filter { $0.id != collection.id }
        
        listenerSubject.send(collections)
    }
    
    public func editCollection(_ collection: DeckCollection) throws {
        if shouldThrowError {
            throw RepositoryError.couldNotEdit
        }
        
        guard let collectionIndex = collections.firstIndex(where: { $0.id == collection.id }) else {
            throw RepositoryError.couldNotEdit
        }
        
        collections[collectionIndex] = collection
        
        listenerSubject.send(collections)
    }
    
    public func listener() -> AnyPublisher<[DeckCollection], RepositoryError> {
        listenerSubject.eraseToAnyPublisher()
    }
}
