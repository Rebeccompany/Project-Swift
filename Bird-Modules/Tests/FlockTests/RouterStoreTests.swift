//
//  RouterStoreTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 13/09/22.
//

import XCTest
@testable import Flock
import Models

final class RouterStoreTests: XCTestCase {
    
    var sut: RouterStore<StudyRoute>!
    
    
    var route: StudyRoute {
        let dummyDeck = Deck(
            id: UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!,
            name: "New Deck",
            icon: "chevron.down",
            color: .darkBlue,
            datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0), lastEdit: Date(timeIntervalSince1970: 0), createdAt: Date(timeIntervalSince1970: 0)),
            collectionsIds: [],
            cardsIds: []
        )
        return StudyRoute.deck(dummyDeck)
    }
    
    var cardRoute: StudyRoute {
        let dummyCard = Card(
            id: UUID(uuidString: "a498bc3c-85a3-4784-b560-a33a272a0a92")!,
            front: AttributedString(stringLiteral: "front"),
            back: AttributedString(stringLiteral: "back"),
            color: .darkBlue,
            datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0), lastEdit: Date(timeIntervalSince1970: 0), createdAt: Date(timeIntervalSince1970: 0)),
            deckID: UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!,
            woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
            history: [])
        
        return StudyRoute.card(dummyCard)
    }
    
    override func setUp() {
        sut = RouterStore<StudyRoute>()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testPushRoute() {
        XCTAssertTrue(sut.path.isEmpty)
        
        sut.push(route: route)
        
        XCTAssertEqual(1, sut.path.count)
    }
    
    func testPopRouteWithEmptyStack() {
        XCTAssertTrue(sut.path.isEmpty)
        
        sut.popLast()
        
        XCTAssertTrue(sut.path.isEmpty)
    }
    
    func testPopRouteWithMultipleElementInStack() {
        sut.push(route: route)
        sut.push(route: cardRoute)
        
        XCTAssertEqual(2, sut.path.count)
        
        sut.popLast()
        
        XCTAssertEqual(1, sut.path.count)
    }
    
    func testPopRouteWithOneElementInStack() {
        sut.push(route: route)
        XCTAssertEqual(1, sut.path.count)
        
        sut.popLast()
        
        XCTAssertTrue(sut.path.isEmpty)
    }
}
