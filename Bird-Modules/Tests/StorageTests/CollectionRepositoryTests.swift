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
    
    
    override func setUpWithError() throws {
        
        
        dataStorage = DataStorage(.inMemory)
        
        collectionTransformer = CollectionModelEntityTransformer()
        collectionRepository = Repository(transformer: collectionTransformer, dataStorage)
        
        deckTransformer = DeckModelEntityTransformer()
        deckRepository = Repository(transformer: deckTransformer, dataStorage)
        
        sut = CollectionRepository(collectionRepository: collectionRepository,
                                   deckRepository: deckRepository)
    }

    override func tearDownWithError() throws {
        collectionRepository = nil
        deckRepository = nil
        deckTransformer = nil
        dataStorage = nil
        sut = nil
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
        XCTAssertTrue(deckEntity.collections!.contains(resultCollection))
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
        XCTAssertTrue(!deckEntity.collections!.contains(resultCollection))
    }
    
    func testCreateCollection() throws {
        let collection = DeckCollectionDummy.dummy
        try sut.createCollection(collection)
        
        let resultCollections = try collectionRepository.fetchEntityById(collection.id)
        XCTAssertEqual(resultCollections.id, collection.id)
    }
    
    func testListener() throws {
        
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
