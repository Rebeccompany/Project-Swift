//
//  WpGetTodayTests.swift
//  
//
//  Created by Caroline Taus on 22/08/22.
//

import XCTest
@testable import Woodpecker
import Models

class WpGetTodayTests: XCTestCase {
    
    // Learning stage with 4 cards never been presented and 0 that have been presented
    func testLearning4N0HB() {
        let result = try! Woodpecker.getTodaysCards(cardsInfo: SchedulerInfoDummy.LNHB,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayCards.sorted(by: sortUUID), SchedulerInfoDummy.LNHB.map({ $0.cardId }).sorted(by: sortUUID))
    }
    
    func testLearning2N2HB() {
        
    }
    
    func testLearning
    
    
    
    
    
    
    
    
    private func sortUUID(a: UUID, b: UUID) -> Bool {
        a.uuidString < b.uuidString
    }
    
    
}
