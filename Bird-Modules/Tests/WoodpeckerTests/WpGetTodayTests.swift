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
    let today: Date = Date(timeIntervalSince1970: 0)
    
    // Learning stage with 40 cards never been presented and 0 that have been presented
    func testLearning40N0HB() {
        let cards = [Card(id: UUID(),
                          front: "",
                          back: "",
                          datesLogs: DateLogs(lastAccess: Date(),
                                              lastEdit: Date(),
                                              createdAt: Date()),
                          deckID: UUID(),
                          woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                 isGraduated: false,
                                                                 easeFactor: 2.5,
                                                                 streak: 0,
                                                                 interval: 0,
                                                                 hasBeenPresented: false),
                          history: []),
                     Card(id: UUID(),
                          front: "",
                          back: "",
                          datesLogs: DateLogs(lastAccess: Date(),
                                              lastEdit: Date(),
                                              createdAt: Date()),
                          deckID: UUID(),
                          woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                 isGraduated: false,
                                                                 easeFactor: 2.5, streak: 0,
                                                                 interval: 0,
                                                                 hasBeenPresented: false),
                          history: []),
                     
        ]
        let resultCards = try! Woodpecker.getTodaysCards(cards: [], config: SpacedRepetitionConfig(maxLearningCards: 4, maxReviewingCards: 4), currentDate: today)
        
    }
    
    // Learning Has Been Presented Cards
    let LHB: [Card] = []
    // Learning Has Not Been Presented Cards
    let LNHB: [Card] = []
    
    // Reviewing Today Cards
    let RDT: [Card] = []
    // Reviewing Yesterday Cards
    let RDY: [Card] = []
    // Reviewing Later Cards
    let RDL: [Card]

}
