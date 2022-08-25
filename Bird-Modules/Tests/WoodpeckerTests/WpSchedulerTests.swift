//
//  WpSchedulerTests.swift
//  
//
//  Created by Caroline Taus on 22/08/22.
//

import XCTest
@testable import Woodpecker
import Models

class WpSchedulerTests: XCTestCase {
    
    // MARK: Learning Tests
    // Learning stage with 4 cards never been presented and 0 that have been presented
    func testLearning4N0HB() {
        let result = try! Woodpecker.wpScheduler(cardsInfo: SchedulerInfoDummy.LNHB,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayCards.sorted(by: sortUUID), SchedulerInfoDummy.LNHB.map({ $0.cardId }).sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 2 cards never been presented and 2 that have been presented
    func testLearning2N2HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB.prefix(2) + SchedulerInfoDummy.LHB.prefix(2))
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayCards.sorted(by: sortUUID), cardsInfos.map({ $0.cardId }).sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 0 cards never been presented and 4 that have been presented
    func testLearning0N4HB() {
        let cardsInfos = SchedulerInfoDummy.LHB
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayCards.sorted(by: sortUUID), cardsInfos.map({ $0.cardId }).sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 2 cards never been presented and 0 that have been presented
    func testLearning2N0HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB.prefix(2))
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayCards.sorted(by: sortUUID), cardsInfos.map({ $0.cardId }).sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 0 cards never been presented and 2 that have been presented
    func testLearning0N2HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LHB.prefix(2))
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayCards.sorted(by: sortUUID), cardsInfos.map({ $0.cardId }).sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 2 cards never been presented and 4 that have been presented
    func testLearning2N4HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB.prefix(2) + SchedulerInfoDummy.LHB)
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayCards.sorted(by: sortUUID), SchedulerInfoDummy.LHB.map({ $0.cardId }).sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 4 cards never been presented and 2 that have been presented
    func testLearning4N2HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB + SchedulerInfoDummy.LHB.prefix(2))
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertTrue(result.todayCards.contains(where: { $0 == SchedulerInfoDummy.LHB.prefix(2).map({ $0.cardId })[0] }))
        XCTAssertTrue(result.todayCards.contains(where: { $0 == SchedulerInfoDummy.LHB.prefix(2).map({ $0.cardId })[1] }))
        var count = 0
        for r in result.todayCards {
            if SchedulerInfoDummy.LNHB.map({ $0.cardId }).contains(where: { $0 == r }) {
                count += 1
            }
        }
        XCTAssertEqual(count, 2)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    
    // MARK: Reviewing Tests
    // P = past; T = today; F = future
    
    func test0P0T1F() {
        let pastCards: [SchedulerCardInfo] = []
        let todayCards: [SchedulerCardInfo] = []
        let futureCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(1))
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertTrue(result.todayCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func test0P0T0F() {
        let pastCards: [SchedulerCardInfo] = []
        let todayCards: [SchedulerCardInfo] = []
        let futureCards: [SchedulerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertTrue(result.todayCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func test0P1T1F() {
        let pastCards: [SchedulerCardInfo] = []
        let todayCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(1))
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(todayCards.map({$0.cardId}), result.todayCards)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func test0P1T0F() {
        let pastCards: [SchedulerCardInfo] = []
        let todayCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [SchedulerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(todayCards.map({$0.cardId}), result.todayCards)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func test1P0T0F() {
        let pastCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [SchedulerCardInfo] = []
        let futureCards: [SchedulerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(pastCards.map({$0.cardId}), result.todayCards)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func test1P1T0F() {
        let pastCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [SchedulerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(cardsInfos.map({$0.cardId}).sorted(by: sortUUID), result.todayCards.sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func test1P0T1F() {
        let pastCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [SchedulerCardInfo] = []
        let futureCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(1))
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(pastCards.map({$0.cardId}), result.todayCards)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func test2P1T0F() {
        let pastCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(2))
        let todayCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [SchedulerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        var count = 0
        for r in result.todayCards {
            if cardsInfos.map({ $0.cardId }).contains(where: { $0 == r }) {
                count += 1
            }
        }
        XCTAssertEqual(count, 2)
        var countModify = 0
        for r in result.toModify {
            if cardsInfos.map({ $0.cardId }).contains(where: { $0 == r }) {
                countModify += 1
            }
        }
        XCTAssertEqual(countModify, 1)
    }
    
    func test1P2T0F() {
        let pastCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(2))
        let futureCards: [SchedulerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        var count = 0
        for r in result.todayCards {
            if cardsInfos.map({ $0.cardId }).contains(where: { $0 == r }) {
                count += 1
            }
        }
        XCTAssertEqual(count, 2)
        
        
        var countModify = 0
        for r in result.toModify {
            if cardsInfos.map({ $0.cardId }).contains(where: { $0 == r }) {
                countModify += 1
            }
        }
        XCTAssertEqual(countModify, 1)
    }
    
    func test2P2T2F() {
        let pastCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(2))
        let todayCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(2))
        let futureCards: [SchedulerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(2))
        let cardsInfos = pastCards + todayCards + futureCards
        let pastAndToday = pastCards + todayCards
        let result = try! Woodpecker.wpScheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        var countToday = 0
        for r in result.todayCards {
            if pastAndToday.map({ $0.cardId }).contains(where: { $0 == r }) {
                countToday += 1
            }
        }
        XCTAssertEqual(countToday, 2)
        
        var countModify = 0
        for r in result.toModify {
            if pastAndToday.map({ $0.cardId }).contains(where: { $0 == r }) {
                countModify += 1
            }
        }
        XCTAssertEqual(countModify, 2)

        var hasRepeated: Bool = false
        for x in result.todayCards {
            for y in result.toModify {
                if x == y {
                    hasRepeated = true
                }
            }
        }
        
        XCTAssertTrue(!hasRepeated)
    }
    
    // MARK: Error tests
    func testMaxReviewingAndLearning0() {
        do {
            let _ = try Woodpecker.wpScheduler(cardsInfo: [],
                                                     config: SpacedRepetitionConfig(maxLearningCards: 0,
                                                                                    maxReviewingCards: 1),
                                                     currentDate: SchedulerInfoDummy.today)
        } catch {
            let learningError = WoodpeckerSchedulerErrors.maxLearningNotGreaterThan0
            let error = error as? WoodpeckerSchedulerErrors
            XCTAssertEqual(error, learningError)
        }
        
        do {
            let _ = try Woodpecker.wpScheduler(cardsInfo: [],
                                                     config: SpacedRepetitionConfig(maxLearningCards: 1,
                                                                                    maxReviewingCards: 0),
                                                     currentDate: SchedulerInfoDummy.today)
        } catch {
            let reviewingError = WoodpeckerSchedulerErrors.maxReviewingNotGreaterThan0
            let error = error as? WoodpeckerSchedulerErrors
            XCTAssertEqual(error, reviewingError)
        }
        
        
    }
   
    
    
    
    
    
    
    
    private func sortUUID(a: UUID, b: UUID) -> Bool {
        a.uuidString < b.uuidString
    }
    
    
}
