//
//  Card+EntityIntegrationTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import XCTest
@testable import Storage
import Models
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

class CardEntityIntegrationTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    
    var dummyCard: Card {
        let id = UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")!
        let deckId = UUID(uuidString: "25804f37-a401-4211-b8d1-ac2d3de53775")!
        let frontData = "Toxoplasmose: exame e seus respectivo tempo e tratamento".data(using: .utf8)!
        let backData =  ". Sorologia (IgM,IgG) -&gt; Teste de Avidez (&lt;30% aguda, &gt;60% cronica)&nbsp;<br>. Espiramicina 3g -VO 2 cp de 500mg por 8/8h&nbsp;".data(using: .utf8)!
        
        let frontNSAttributedString = try! NSAttributedString(data: frontData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let backNSAttributedString = try! NSAttributedString(data: backData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        let wp = WoodpeckerCardInfo(step: 1,
                                    isGraduated: true,
                                    easeFactor: 2.5,
                                    streak: 1,
                                    interval: 1)
        
        return Card(id: id, front: AttributedString(frontNSAttributedString), back: AttributedString(backNSAttributedString), datesLogs: dateLog, deckID: deckId, woodpeckerCardInfo: wp, history: [])
        
    }
    
    override func setUp() {
        dataStorage = .init(StoreType.inMemory)
    }
    
    override func tearDown() {
        dataStorage = nil
    }
    
    func testCreateEntityFromModel() {
        let entity = CardEntity(with: dummyCard, on: dataStorage.mainContext)
        assertModel(model: dummyCard, entity: entity)
    }
    
    func testCreateModelFromEntity() throws {
        let entity = CardEntity(with: dummyCard, on: dataStorage.mainContext)
        let deck = DeckEntity(context: dataStorage.mainContext)
        deck.id = UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")
        entity.deck = deck
        
        try dataStorage.save()
        
        
        let card = Card(entity: entity)!
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
