//
//  CollectionRepositoryTests.swift
//  
//
//  Created by Marcos Chevis on 29/08/22.
//

import XCTest
@testable import Storage
import Combine
import Models

class CollectionRepositoryTests: XCTestCase {
    
    var sut: CollectionRepository!
    var dataStorage: DataStorage!
    
    var collectionTransformer: CollectionModelEntityTransformer!
    var collectionRepository: Repository<DeckCollection, CollectionEntity, CollectionModelEntityTransformer>!
    
    var deckTransformer: DeckModelEntityTransformer!
    var deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>!
    
    var cancellables: Set<AnyCancellable>!
    
    
    override func setUpWithError() throws {
        
        
        dataStorage = DataStorage(.inMemory)
        
        collectionTransformer = CollectionModelEntityTransformer()
        collectionRepository = Repository(transformer: collectionTransformer, dataStorage)
        
        deckTransformer = DeckModelEntityTransformer()
        deckRepository = Repository(transformer: deckTransformer, dataStorage)
        
        sut = CollectionRepository(collectionRepository: collectionRepository,
                                   deckRepository: deckRepository)
        
        cancellables = .init()
    }
    
    override func tearDownWithError() throws {
        collectionRepository = nil
        deckRepository = nil
        deckTransformer = nil
        dataStorage = nil
        sut = nil
        cancellables.forEach({ $0.cancel() })
        cancellables = nil
    }
    
    func testAddDeck() throws {
        let deck = DeckDummy.dummy
        let collection = DeckCollectionDummy.dummy
        
        let deckEntity = deckTransformer.modelToEntity(deck, on: dataStorage.mainContext)
        try dataStorage.save()
        
        
        try sut.createCollection(collection)
        
        
        try sut.addDeck(deck, in: collection)
        
        let resultCollection = try collectionRepository.fetchEntityById(collection.id)
        
        
        XCTAssertTrue(resultCollection.decks!.contains(deckEntity))
        XCTAssertEqual(deckEntity.collection!, resultCollection)
    }
    
    func testRemoveDeck() throws {
        let deck = DeckDummy.dummy
        let collection = DeckCollectionDummy.dummy
        
        let deckEntity = deckTransformer.modelToEntity(deck, on: dataStorage.mainContext)
        try dataStorage.save()
        
        
        try sut.createCollection(collection)
        
        
        try sut.addDeck(deck, in: collection)
        
        let resultCollection = try collectionRepository.fetchEntityById(collection.id)
        
        try sut.removeDeck(deck, from: collection)
        
        XCTAssertTrue(!resultCollection.decks!.contains(deckEntity))
        XCTAssertEqual(deckEntity.collection, nil)
    }
    
    func testCreateCollection() throws {
        let collection = DeckCollectionDummy.dummy
        try sut.createCollection(collection)
        
        let resultCollection = try collectionRepository.fetchEntityById(collection.id)
        XCTAssertEqual(resultCollection.id, collection.id)
    }
    
    func testDeleteCollection() throws {
        let collection = DeckCollectionDummy.dummy
        try sut.createCollection(collection)
        
        
        try sut.deleteCollection(collection)
        
        XCTAssertThrowsError(try collectionRepository.fetchEntityById(collection.id))
    }
    
    func testEditCollection() throws {
        var collection = DeckCollectionDummy.dummy
        try sut.createCollection(collection)
        
        collection.datesLogs.lastEdit = Date(timeIntervalSince1970: 400)
        collection.name = "newName"
        try sut.editCollection(collection)
        
        let collectionEntity = try collectionRepository.fetchEntityById(collection.id)
        
        XCTAssertEqual(collectionEntity.lastEdit, collection.datesLogs.lastEdit)
        XCTAssertEqual(collectionEntity.name, collection.name)
    }
    
    func testListener() throws {
        var ids = UUIDDummy
            .dummy
            .enumerated()
            .filter { index, _ in index % 2 == 0 }
            .map(\.element)
        
        try ids
            .map(DeckCollectionDummy.newDummyDeck(with:))
            .forEach { try sut.createCollection($0)}
        
        let expectation = expectation(description: "Wait for listening to finish")
        let listenOccurrencesExpectation = 1
        var listenOccurences = 0
        
        sut.listener()
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
        try sut.createCollection(DeckCollectionDummy.dummy)
        
        wait(for: [expectation], timeout: 1)
    }
    
}
