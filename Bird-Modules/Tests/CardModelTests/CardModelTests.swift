//
//  CardModelTests.swift
//  
//
//  Created by Caroline Taus on 22/08/22.
//

import XCTest
@testable import Models
import Utils

class CardModelTests: XCTestCase {
    
    var sut: Card!
    let secondsInADay: TimeInterval = 86400
    
    override func setUpWithError() throws {
        sut = Card(id: UUID(), front: "", back: "", color: .red, datesLogs: DateLogs(lastAccess: Date(), lastEdit: Date(), createdAt: Date()), deckID: UUID(), woodpeckerCardInfo: WoodpeckerCardInfo(step: 2, isGraduated: true, easeFactor: 2.5, streak: 2, interval: 0, hasBeenPresented: true), history: [])   
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    // Testing set dueDate
    func testSet() {
        var card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: 0, timeZone: TimeZone.current), interval: 0)
        card.dueDate = Date(timeIntervalSince1970: secondsInADay, timeZone: TimeZone.current)
        XCTAssertEqual(card.woodpeckerCardInfo.interval, 1)
    }
    
    // Testing set dueDate with negative interval
    func testSetNegative() {
        var card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: 0, timeZone: TimeZone.current), interval: 0)
        card.dueDate = Date(timeIntervalSince1970: -secondsInADay, timeZone: TimeZone.current)
        XCTAssertEqual(card.woodpeckerCardInfo.interval, 0)
    }
    
    // I = interval; H = Hour of last snapshot
    // Testing the dueDate for a card with interval = 0 and last snapshot at 01/01/1970 12:00
    func testI0H12() {
        let card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: secondsInADay/2, timeZone: TimeZone.current), interval: 0)
    
        XCTAssertEqual(getComponents(date: card.dueDate!), getComponents(date: Date(timeIntervalSince1970: 0, timeZone: TimeZone.current)))
    }
    
    // Testing the dueDate for a card with interval = 0 and last snapshot at 01/01/1970 00:00
    func testI0H0() {
        let card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: 0, timeZone: TimeZone.current), interval: 0)
    
        XCTAssertEqual(getComponents(date: card.dueDate!), getComponents(date: Date(timeIntervalSince1970: 0, timeZone: TimeZone.current)))
    }
    
    // Testing the dueDate for a card with interval = 0 and last snapshot at 01/01/1970 06:00
    func testI0H6() {
        let card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: 6 * 3600, timeZone: TimeZone.current), interval: 0)
    
        XCTAssertEqual(getComponents(date: card.dueDate!), getComponents(date: Date(timeIntervalSince1970: 0, timeZone: TimeZone.current)))
    }

    // Testing the dueDate for a card with interval = 1 and last snapshot at 01/01/1970 12:00
    func testI1H12() {
        let card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: secondsInADay/2, timeZone: TimeZone.current), interval: 1)
    
        XCTAssertEqual(getComponents(date: card.dueDate!), getComponents(date: Date(timeIntervalSince1970: secondsInADay, timeZone: TimeZone.current)))
    }
    
    // Testing the dueDate for a card with interval = 1 and last snapshot at 01/01/1970 00:00
    func testI1H0() {
        let card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: 0, timeZone: TimeZone.current), interval: 1)
    
        XCTAssertEqual(getComponents(date: card.dueDate!), getComponents(date: Date(timeIntervalSince1970: secondsInADay, timeZone: TimeZone.current)))
    }
    
    // Testing the dueDate for a card with interval = 1 and last snapshot at 01/01/1970 06:00
    func testI1H6() {
        let card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: 6 * 3600, timeZone: TimeZone.current), interval: 1)
    
        XCTAssertEqual(getComponents(date: card.dueDate!), getComponents(date: Date(timeIntervalSince1970: secondsInADay, timeZone: TimeZone.current)))
    }
    
    // Testing the dueDate for a card with interval = 200 and last snapshot at 01/01/1970 06:00
    func testI200H6() {
        let card = getCard(sut: sut, snapshotDate: Date(timeIntervalSince1970: 6 * 3600, timeZone: TimeZone.current), interval: 200)
    
        XCTAssertEqual(getComponents(date: card.dueDate!), getComponents(date: Date(timeIntervalSince1970: 200 * secondsInADay, timeZone: .current)))
    }
    
    private func getCard(sut: Card?, snapshotDate: Date, interval: Int) ->  Card {
        
        var sut = sut!
        sut.history = [CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(step: 1, isGraduated: true, easeFactor: 2.5, streak: 2, interval: 2, hasBeenPresented: true), userGrade: .correct, timeSpend: 3, date: snapshotDate)]
        sut.woodpeckerCardInfo.interval = interval
        
        return sut
    }
    
    private func getComponents(date: Date) -> DateComponents {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.current
        return cal.dateComponents([.day, .month, .year], from: date)
    }

}
