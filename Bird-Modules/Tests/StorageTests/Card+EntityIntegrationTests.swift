//
//  CardModelEntityTransformerTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import XCTest
@testable import Storage
import Models
import SwiftUI

class CardModelEntityTransformerTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    var sut: CardModelEntityTransformer! = nil
    
    override func setUp() {
        dataStorage = .init(StoreType.inMemory)
        sut = .init()
    }
    
    override func tearDown() {
        dataStorage = nil
        sut = nil
    }
    
    func testCreateEntityFromModel() {
        let dummyCard = CardDummy.dummy
        
        let entity = sut.modelToEntity(dummyCard, on: dataStorage.mainContext)
        assertModel(model: dummyCard, entity: entity)
    }
    
    func testCreateModelFromEntity() throws {
        let dummyCard = CardDummy.dummy
        
        let entity = sut.modelToEntity(dummyCard, on: dataStorage.mainContext)
        let deck = DeckEntity(context: dataStorage.mainContext)
        deck.id = UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")
        entity.deck = deck
        
        try dataStorage.save()
        
        
        let card = sut.entityToModel(entity)!
        assertEntity(model: card, entity: entity)
    }
    
    private func assertModel(model: Card, entity: CardEntity) {
        XCTAssertEqual(model.id, entity.id)
        XCTAssertEqual(model.datesLogs.lastEdit, entity.lastEdit)
        XCTAssertEqual(model.datesLogs.createdAt, entity.createdAt)
        XCTAssertEqual(model.datesLogs.lastAccess, entity.lastAccess)
        XCTAssertEqual(model.woodpeckerCardInfo.easeFactor, entity.wpEaseFactor)
        XCTAssertEqual(model.woodpeckerCardInfo.interval, Int(entity.wpInterval))
        XCTAssertEqual(model.woodpeckerCardInfo.step, Int(entity.wpStep))
        XCTAssertEqual(model.woodpeckerCardInfo.streak, Int(entity.wpStreak))
        XCTAssertEqual(entity.deck, nil)
        XCTAssertEqual(entity.history?.array.isEmpty, true)
        
        let frontNS = try! NSAttributedString(data: entity.front!, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
        let backNS = try! NSAttributedString(data: entity.back!, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
        
        XCTAssertEqual(NSAttributedString(model.front).string, frontNS.string)
        XCTAssertEqual(NSAttributedString(model.back).string, backNS.string)
    }
    
    private func assertEntity(model: Card, entity: CardEntity) {
        XCTAssertEqual(model.id, entity.id)
        XCTAssertEqual(model.datesLogs.lastEdit, entity.lastEdit)
        XCTAssertEqual(model.datesLogs.createdAt, entity.createdAt)
        XCTAssertEqual(model.datesLogs.lastAccess, entity.lastAccess)
        XCTAssertEqual(model.woodpeckerCardInfo.easeFactor, entity.wpEaseFactor)
        XCTAssertEqual(model.woodpeckerCardInfo.interval, Int(entity.wpInterval))
        XCTAssertEqual(model.woodpeckerCardInfo.step, Int(entity.wpStep))
        XCTAssertEqual(model.woodpeckerCardInfo.streak, Int(entity.wpStreak))
        XCTAssertEqual(entity.deck!.id, model.deckID)
        XCTAssertEqual(entity.history?.array.isEmpty, true)
        
        let frontNS = try! NSAttributedString(data: entity.front!, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
        let backNS = try! NSAttributedString(data: entity.back!, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
        
        XCTAssertEqual(NSAttributedString(model.front).string, frontNS.string)
        XCTAssertEqual(NSAttributedString(model.back).string, backNS.string)
    }

}
