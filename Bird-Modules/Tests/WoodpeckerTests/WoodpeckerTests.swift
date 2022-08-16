//
//  WoodpeckerTests.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import XCTest
@testable import Woodpecker


struct testCardInfo {
    var input: SM2CardInfo
    var ExpectedOutput: SM2CardInfo
}

class WoodpeckerTests: XCTestCase {
    
    var testsData: [testCardInfo] = {
        return [
            .init(input:          SM2CardInfo(userGrade: 0,
                                              streak: 0,
                                              easeFactor: 2.5,
                                              interval: 0),
                  ExpectedOutput: SM2CardInfo(userGrade: 0,
                                              streak: 0,
                                              easeFactor: 1.7,
                                              interval: 1))
            
        
        ]
    }()

    override func tearDownWithError() throws {

    }
    
    func testSM2() {
        
        for data in testsData {
            let testingResult = SM2CardInfo.SM2(data.input)
            XCTAssertEqual(testingResult.interval, data.ExpectedOutput.interval)
            XCTAssertEqual(testingResult.streak, data.ExpectedOutput.streak)
            XCTAssertEqual(testingResult.easeFactor, data.ExpectedOutput.easeFactor)
        }
    }

}
