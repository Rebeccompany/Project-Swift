//
//  Deck+EntityTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/08/22.
//

import XCTest
@testable import Storage
import Models

class DeckEntityTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    
    var deck: Deck {
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
    }
    
    override func tearDown() {
        dataStorage = nil
    }
    
    func testDeckToEntity() throws {
        let deck = self.deck
        let entity = DeckEntity(withData: deck, on: dataStorage.mainContext)
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
        _ = DeckEntity(withData: deck, on: dataStorage.mainContext)
        try dataStorage.save()
        
        let saved = try dataStorage.mainContext.fetch(DeckEntity.fetchRequest()).first!
        let model = Deck(entity: saved)
        
        XCTAssertEqual(model, deck)
    }
    
}
