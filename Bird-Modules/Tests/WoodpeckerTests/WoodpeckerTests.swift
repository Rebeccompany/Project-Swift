//
//  WoodpeckerTests.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import XCTest
@testable import Woodpecker

class WoodpeckerTests: XCTestCase {
    
    var cardInfo: RepetitionAlgorithms.SM2CardInfo = {
        return .init(userGrade: 0,
                     streak: 0,
                     easeFactor: 2.5,
                     interval: 0)
    }()

    override func tearDownWithError() throws {
    cardInfo = .init(userGrade: 0,
                     streak: 0,
                     easeFactor: 2.5,
                     interval: 0)
    }
    
    func testSM2() {
        cardInfo = .init(userGrade: 0,
                         streak: 0,
                         easeFactor: 2.5,
                         interval: 0)
        
        let result = RepetitionAlgorithms.SM2(cardInfo)
        
        XCTAssertEqual(result.interval, 1)
        XCTAssertEqual(result.streak, 0)
        XCTAssertEqual(result.easeFactor, 1.7)
    }

}
