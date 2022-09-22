//
//  CollectionRepositoryTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/08/22.
//

import XCTest
@testable import Storage
import Models
import CoreData
import Combine

class RepositoryTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    var sut: Repository<DeckCollection, CollectionEntity, CollectionModelEntityTransformer>! = nil
    var cancellables: Set<AnyCancellable>! = nil
    
    func collectionRequest(for id: UUID) -> NSFetchRequest<CollectionEntity> {
        let fetchRequest = CollectionEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        return fetchRequest
    }
    
    override func setUp() {
        dataStorage = DataStorage(StoreType.inMemory)
        sut = Repository(transformer: CollectionModelEntityTransformer(), dataStorage)
        cancellables = .init()
    }
    
    override func tearDown() {
        sut = nil
        dataStorage = nil
        
        cancellables.forEach { c in
            c.cancel()
        }
        
        cancellables = nil
    }
    
    func testCreate() throws {
        let count = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(0, count)
        
        try sut.create(DeckCollectionDummy.dummy)
        
        let result = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(1, result)
    }
    
    func testDelete() throws {
        try sut.create(DeckCollectionDummy.dummy)
        
        var count = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(1, count)
        
        try sut.delete(DeckCollectionDummy.dummy)
        
        count = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(0, count)
    }
    
    func testFetchAll() throws {
        let expectation = expectation(description: "Wait for fetching")
        try sut.create(DeckCollectionDummy.dummy)
        
        sut.fetchAll()
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { value in
                XCTAssertFalse(value.isEmpty)
                XCTAssertEqual(value.first!.id, DeckCollectionDummy.dummy.id)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchByMultipleId() throws {
        try UUIDDummy.dummy
            .map(DeckCollectionDummy.newDummyDeck(with:))
            .forEach {
                try sut.create($0)
            }
        
        try sut.create(DeckCollectionDummy.dummy)
        
        let initialCount = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(UUIDDummy.dummy.count + 1, initialCount)
        
        let expectation = expectation(description: "Wait for fetching by id")
        
        let queryIds = UUIDDummy
            .dummy
            .enumerated()
            .filter { index, _ in index % 2 == 0 }
            .map(\.element)
        
        sut.fetchMultipleById(queryIds)
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { values in
                XCTAssertEqual(values.count, queryIds.count)
                
                values.forEach { collection in
                    let doesContainId = queryIds.contains(collection.id)
                    XCTAssertTrue(doesContainId)
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testListener() throws {
        var ids = UUIDDummy
            .dummy
            .enumerated()
            .filter { index, _ in index % 2 == 0 }
            .map(\.element)
        
        try ids
            .map(DeckCollectionDummy.newDummyDeck(with:))
            .forEach { try sut.create($0) }
        
        let expectation = expectation(description: "Wait for listening to finish")
        let listenOccurrencesExpectation = 1
        var listenOccurences = 0
        
        try sut.listener()
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { values in
                XCTAssertEqual(ids.count, values.count)
                
                values.forEach { collection in
                    let doesContainId = ids.contains(collection.id)
                    XCTAssertTrue(doesContainId)
                }
                
                if listenOccurrencesExpectation == listenOccurences {
                    expectation.fulfill()
                }
                listenOccurences += 1
            }
            .store(in: &cancellables)
        
        ids.append(DeckCollectionDummy.dummy.id)
        try sut.create(DeckCollectionDummy.dummy)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testListenerWithCustomPredicate() throws {
        let ids = UUIDDummy
            .dummy
            .enumerated()
            .filter { index, _ in index % 2 == 0 }
            .map(\.element)
        
        var collections = ids
            .map(DeckCollectionDummy.newDummyDeck(with:))
        
        let expectedDeckName = "Programação Rust"
        
        collections.append(DeckCollection(
            id: UUID(),
            name: expectedDeckName,
            icon: .atom,
            datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                lastEdit: Date(timeIntervalSince1970: 0),
                                createdAt: Date(timeIntervalSince1970: 0)),
            decksIds: []))
        
        try collections.forEach { try sut.create($0) }
        
        var expectedDeckCollections = collections.filter { $0.name == expectedDeckName }
        let predicated = NSPredicate(format: "name == %@", expectedDeckName)
        
        let expectation = expectation(description: "Listener Receive Correct information")
        
        let listenOccurrencesExpectation = 1
        var listenOccurences = 0
        
        try sut.listener(for: predicated)
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { collections in
                XCTAssertEqual(collections.count, expectedDeckCollections.count)
                
                collections.forEach { collection in
                    let doesContainCollection = expectedDeckCollections.contains(collection)
                    XCTAssertTrue(doesContainCollection)
                }
                
                if listenOccurrencesExpectation == listenOccurences {
                    expectation.fulfill()
                }
                listenOccurences += 1
            }
            .store(in: &cancellables)
        
        var newDummy = DeckCollectionDummy.dummy
        newDummy.name = expectedDeckName
        expectedDeckCollections.append(newDummy)
        
        try sut.create(DeckCollection(id: UUID(), name: "ignorar", icon: .abc, datesLogs: DateLogs(), decksIds: []))
        try sut.create(newDummy)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchById() throws {
        let expectation = expectation(description: "Wait for fetching single element")
        
        try UUIDDummy.dummy
            .map(DeckCollectionDummy.newDummyDeck(with:))
            .forEach { try sut.create($0)}
        
        try sut.create(DeckCollectionDummy.dummy)
        
        sut.fetchById(DeckCollectionDummy.dummy.id)
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { collection in
                XCTAssertEqual(collection, DeckCollectionDummy.dummy)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
