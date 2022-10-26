//
//  SessionModelEntityTransformerTests.swift
//
//
//  Created by Nathalia do Valle Papst on 05/10/22.
//

import XCTest
@testable import Storage
import Models
import SwiftUI

class SessionModelEntityTransformerTests: XCTestCase {
    var dataStorage: DataStorage! = nil
    var sut: SessionModelEntityTransformer! = nil
    
    override func setUp() {
        dataStorage = .init(StoreType.inMemory)
        sut = .init()
    }
    
    override func tearDown() {
        dataStorage = nil
        sut = nil
    }
    
    func testCreateEntityFromModel() {
        let dummySession = SessionDummy.dummy
        let entity = sut.modelToEntity(dummySession, on: dataStorage.mainContext)
        
        XCTAssertEqual(dummySession.id, entity.id)
        XCTAssertEqual(dummySession.date, entity.date)
    }
    
    func testCreateModelFromEntity() throws {
        let card = CardDummy.dummy
        let deck = DeckDummy.newDummy(with: UUID(uuidString: "1bdcc8a0-467e-4dd2-b02a-5cce07997a0c")!)
        
        let dummySession = SessionDummy.dummy
        let entity = sut.modelToEntity(dummySession, on: dataStorage.mainContext)
        
        try dataStorage.mainContext.save()
        
        let cardTransformer = CardModelEntityTransformer()
        let cardEntity = cardTransformer.modelToEntity(card, on: dataStorage.mainContext)
        
        let deckTransformer = DeckModelEntityTransformer()
        let deckEntity = deckTransformer.modelToEntity(deck, on: dataStorage.mainContext)
        
        deckEntity.session = entity
        deckEntity.addToCards(cardEntity)
        entity.addToCards(cardEntity)
        
        try dataStorage.mainContext.save()
        
        let model = sut.entityToModel(entity)
        
        XCTAssertEqual(model, dummySession)
    }
}
