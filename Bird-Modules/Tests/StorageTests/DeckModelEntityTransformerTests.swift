//
//  DeckModelEntityTransformerTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/08/22.
//

import XCTest
@testable import Storage
import Models

class DeckModelEntityTransformerTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    var sut: DeckModelEntityTransformer! = nil
    
    override func setUp() {
        dataStorage = DataStorage(StoreType.inMemory)
        sut = .init()
    }
    
    override func tearDown() {
        dataStorage = nil
        sut = nil
    }
    
    func testDeckToEntity() throws {
        let deck = DeckDummy.dummy
        let entity = sut.modelToEntity(deck, on: dataStorage.mainContext)
        try dataStorage.save()
        let count = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        XCTAssertEqual(1, count)
        
        XCTAssertEqual(deck.id, entity.id)
        XCTAssertEqual(deck.name, entity.name)
        XCTAssertEqual(deck.datesLogs.createdAt, entity.createdAt)
        XCTAssertEqual(deck.datesLogs.lastAccess, entity.lastAccess)
        XCTAssertEqual(deck.datesLogs.lastEdit, entity.lastEdit)
        XCTAssertEqual(deck.spacedRepetitionConfig.maxLearningCards, Int(entity.maxLearningCards))
        XCTAssertEqual(deck.spacedRepetitionConfig.maxReviewingCards, Int(entity.maxReviewingCards))
    }
    
    func testEntityToDeck() throws {
        _ = sut.modelToEntity(DeckDummy.dummy, on: dataStorage.mainContext)
        try dataStorage.save()
        
        let saved = try dataStorage.mainContext.fetch(DeckEntity.fetchRequest()).first!
        let model = sut.entityToModel(saved)
        
        XCTAssertEqual(model, DeckDummy.dummy)
    }
    
}
