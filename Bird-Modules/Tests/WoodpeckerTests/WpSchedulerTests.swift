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
        let result = try! Woodpecker.scheduler(cardsInfo: SchedulerInfoDummy.LNHB,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayLearningCards.sorted(by: sortUUID), SchedulerInfoDummy.LNHB.map({ $0.id }).sorted(by: sortUUID))
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 2 cards never been presented and 2 that have been presented
    func testLearning2N2HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB.prefix(2) + SchedulerInfoDummy.LHB.prefix(2))
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayLearningCards.sorted(by: sortUUID), cardsInfos.map({ $0.id }).sorted(by: sortUUID))
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 0 cards never been presented and 4 that have been presented
    func testLearning0N4HB() {
        let cardsInfos = SchedulerInfoDummy.LHB
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayLearningCards.sorted(by: sortUUID), cardsInfos.map({ $0.id }).sorted(by: sortUUID))
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 2 cards never been presented and 0 that have been presented
    func testLearning2N0HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB.prefix(2))
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayLearningCards.sorted(by: sortUUID), cardsInfos.map({ $0.id }).sorted(by: sortUUID))
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 0 cards never been presented and 2 that have been presented
    func testLearning0N2HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LHB.prefix(2))
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayLearningCards.sorted(by: sortUUID), cardsInfos.map({ $0.id }).sorted(by: sortUUID))
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 2 cards never been presented and 4 that have been presented
    func testLearning2N4HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB.prefix(2) + SchedulerInfoDummy.LHB)
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertEqual(result.todayLearningCards.sorted(by: sortUUID), SchedulerInfoDummy.LHB.map({ $0.id }).sorted(by: sortUUID))
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    // Learning stage with 4 cards never been presented and 2 that have been presented
    func testLearning4N2HB() {
        let cardsInfos = Array(SchedulerInfoDummy.LNHB + SchedulerInfoDummy.LHB.prefix(2))
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                  config: SpacedRepetitionConfig(maxLearningCards: 4,
                                                                 maxReviewingCards: 4),
                                       currentDate: SchedulerInfoDummy.today)
        
        
        XCTAssertTrue(result.todayLearningCards.contains(where: { $0 == SchedulerInfoDummy.LHB.prefix(2).map({ $0.id })[0] }))
        XCTAssertTrue(result.todayLearningCards.contains(where: { $0 == SchedulerInfoDummy.LHB.prefix(2).map({ $0.id })[1] }))
        var count = 0
        for r in result.todayLearningCards {
            if SchedulerInfoDummy.LNHB.map({ $0.id }).contains(where: { $0 == r }) {
                count += 1
            }
        }
        XCTAssertEqual(count, 2)
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    
    // MARK: Reviewing Tests
    // P = past; T = today; F = future
    
    func testReviewing0P0T1F() {
        let pastCards: [OrganizerCardInfo] = []
        let todayCards: [OrganizerCardInfo] = []
        let futureCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(1))
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func testReviewing0P0T0F() {
        let pastCards: [OrganizerCardInfo] = []
        let todayCards: [OrganizerCardInfo] = []
        let futureCards: [OrganizerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertTrue(result.todayReviewingCards.isEmpty)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func testReviewing0P1T1F() {
        let pastCards: [OrganizerCardInfo] = []
        let todayCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(1))
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(todayCards.map({$0.id}), result.todayReviewingCards)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func testReviewing0P1T0F() {
        let pastCards: [OrganizerCardInfo] = []
        let todayCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [OrganizerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(todayCards.map({$0.id}), result.todayReviewingCards)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func testReviewing1P0T0F() {
        let pastCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [OrganizerCardInfo] = []
        let futureCards: [OrganizerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(pastCards.map({$0.id}), result.todayReviewingCards)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func testReviewing1P1T0F() {
        let pastCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [OrganizerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(cardsInfos.map({$0.id}).sorted(by: sortUUID), result.todayReviewingCards.sorted(by: sortUUID))
        XCTAssertTrue(result.todayLearningCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func testReviewing1P0T1F() {
        let pastCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [OrganizerCardInfo] = []
        let futureCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(1))
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        XCTAssertEqual(pastCards.map({$0.id}), result.todayReviewingCards)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
        XCTAssertTrue(result.toModify.isEmpty)
    }
    
    func testReviewing2P1T0F() {
        let pastCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(2))
        let todayCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(1))
        let futureCards: [OrganizerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        var count = 0
        for r in result.todayReviewingCards {
            if cardsInfos.map({ $0.id }).contains(where: { $0 == r }) {
                count += 1
            }
        }
        XCTAssertEqual(count, 2)
        var countModify = 0
        for r in result.toModify {
            if cardsInfos.map({ $0.id }).contains(where: { $0 == r }) {
                countModify += 1
            }
        }
        XCTAssertEqual(countModify, 1)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
    }
    
    func testReviewing1P2T0F() {
        let pastCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(1))
        let todayCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(2))
        let futureCards: [OrganizerCardInfo] = []
        let cardsInfos = pastCards + todayCards + futureCards
        
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        var count = 0
        for r in result.todayReviewingCards {
            if cardsInfos.map({ $0.id }).contains(where: { $0 == r }) {
                count += 1
            }
        }
        XCTAssertEqual(count, 2)
        
        
        var countModify = 0
        for r in result.toModify {
            if cardsInfos.map({ $0.id }).contains(where: { $0 == r }) {
                countModify += 1
            }
        }
        XCTAssertEqual(countModify, 1)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
    }
    
    func testReviewing2P2T2F() {
        let pastCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDP.prefix(2))
        let todayCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDT.prefix(2))
        let futureCards: [OrganizerCardInfo] = Array(SchedulerInfoDummy.RDF.prefix(2))
        let cardsInfos = pastCards + todayCards + futureCards
        let pastAndToday = pastCards + todayCards
        let result = try! Woodpecker.scheduler(cardsInfo: cardsInfos,
                                                 config: SpacedRepetitionConfig(maxLearningCards: 2,
                                                                                maxReviewingCards: 2),
                                                 currentDate: SchedulerInfoDummy.today)
        
        var countToday = 0
        for r in result.todayReviewingCards {
            if pastAndToday.map({ $0.id }).contains(where: { $0 == r }) {
                countToday += 1
            }
        }
        XCTAssertEqual(countToday, 2)
        
        var countModify = 0
        for r in result.toModify {
            if pastAndToday.map({ $0.id }).contains(where: { $0 == r }) {
                countModify += 1
            }
        }
        XCTAssertEqual(countModify, 2)

        var hasRepeated: Bool = false
        for x in result.todayReviewingCards {
            for y in result.toModify {
                if x == y {
                    hasRepeated = true
                }
            }
        }
        
        XCTAssertTrue(!hasRepeated)
        XCTAssertTrue(result.todayLearningCards.isEmpty)
    }
    
    // MARK: Error tests
    func testMaxReviewingAndLearning0() {
        do {
            let _ = try Woodpecker.scheduler(cardsInfo: [],
                                                     config: SpacedRepetitionConfig(maxLearningCards: 0,
                                                                                    maxReviewingCards: 1),
                                                     currentDate: SchedulerInfoDummy.today)
        } catch {
            let learningError = WoodpeckerSchedulerErrors.maxLearningNotGreaterThan0
            let error = error as? WoodpeckerSchedulerErrors
            XCTAssertEqual(error, learningError)
        }
        
        do {
            let _ = try Woodpecker.scheduler(cardsInfo: [],
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
