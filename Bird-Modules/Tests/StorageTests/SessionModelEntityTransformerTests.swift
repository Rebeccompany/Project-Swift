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

class SessionInitsTests: XCTestCase {
    var dataStorage: DataStorage! = nil
    
    override func setUp() {
        dataStorage = .init(StoreType.inMemory)
    }
    
    override func tearDown() {
        dataStorage = nil
    }
    
    func testCreateEntityFromModel() throws {
        let entity = try createEntity()
        
        let model = Session(entity: entity)
        
        XCTAssertEqual(model, SessionDummy.dummy)
    }
    
    func testCreateModelFromEntity() throws {
        let entity = try createEntity()
        
        let dummy = SessionDummy.dummy
        let entityCardsIds = entity.cards?.allObjects as? [CardEntity]
        let cardsIds = entityCardsIds?.compactMap(\.id)
        
        XCTAssertEqual(entity.id, dummy.id)
        XCTAssertEqual(entity.date, dummy.date)
        XCTAssertEqual(cardsIds, dummy.cardIds)
        XCTAssertEqual(entity.deck?.id, dummy.deckId)
    }
    
    private func createEntity() throws -> SessionEntity {
        let card = CardDummy.dummy
        let deck = DeckDummy.newDummy(with: UUID(uuidString: "1bdcc8a0-467e-4dd2-b02a-5cce07997a0c")!)
        
        let cardTransformer = CardModelEntityTransformer()
        _ = cardTransformer.modelToEntity(card, on: dataStorage.mainContext)
        
        let deckTransformer = DeckModelEntityTransformer()
        _ = deckTransformer.modelToEntity(deck, on: dataStorage.mainContext)
        
        try dataStorage.mainContext.save()
        
        let entity = try SessionEntity(with: SessionDummy.dummy, on: dataStorage.mainContext)
        
        try dataStorage.save()
        
        return entity
    }
}
