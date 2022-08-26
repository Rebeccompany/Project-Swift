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

class CollectionRepositoryTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    var sut: CollectionRepository! = nil
    var cancellables: Set<AnyCancellable>! = nil
    
    var dummyCollection: DeckCollection {
        DeckCollection(id: UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")!,
                       name: "Coding",
                       iconPath: "chevron.down",
                       datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                           lastEdit: Date(timeIntervalSince1970: 0),
                                           createdAt: Date(timeIntervalSince1970: 0)),
                       decksIds: [])
    }
    
    func collectionRequest(for id: UUID) -> NSFetchRequest<CollectionEntity> {
        let fetchRequest = CollectionEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \CollectionEntity.name, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        return fetchRequest
    }
    
    var dummyDeck: Deck {
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        
        return Deck(id: UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")!,
                    name: "Progamação Swift",
                    icon: "chevron.down",
                    datesLogs: dateLog,
                    collectionsIds: [],
                    cardsIds: [],
                    spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                  maxReviewingCards: 200))
        
    }
    
    override func setUp() {
        dataStorage = DataStorage(StoreType.inMemory)
        sut = CollectionRepository(dataStorage)
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
        
        try sut.create(dummyCollection)
        
        let result = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(1, result)
    }
    
    func testEdit() throws {
        try sut.create(dummyCollection)
        
        let entity = try dataStorage.mainContext.fetch(collectionRequest(for: dummyCollection.id)).first!
        
        XCTAssertEqual(entity.name, dummyCollection.name)
        
        var editedDummy = dummyCollection
        editedDummy.name = "Edited Swift"
        
        try sut.edit(editedDummy)
        
        let editedEntity = try dataStorage.mainContext.fetch(collectionRequest(for: editedDummy.id)).first!
        
        XCTAssertEqual(dummyCollection.id, editedEntity.id)
        XCTAssertEqual(editedDummy.name, editedEntity.name)
    }
    
    func testDelete() throws {
        try sut.create(dummyCollection)
        
        var count = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(1, count)
        
        try sut.delete(dummyCollection)
        
        count = try dataStorage.mainContext.count(for: CollectionEntity.fetchRequest())
        XCTAssertEqual(0, count)
    }
    
    func testFetchAll() throws {
        let expectation = expectation(description: "Wait for fetching")
        try sut.create(dummyCollection)
        
        sut.fetchAll()
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: {[unowned self] value in
                XCTAssertFalse(value.isEmpty)
                XCTAssertEqual(value.first!.id, self.dummyCollection.id)
                expectation.fulfill()
            }.store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchById() throws {
        let expectation = expectation(description: "Wait for fetching by id")
    }
}
