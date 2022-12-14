//
//  WoodpeckerTests.swift
//  
//
//  Created by Marcos Chevis on 15/08/22.
//

import XCTest
@testable import Woodpecker
import Models

final class StepperTests: XCTestCase {

    let cards: [WoodpeckerCardInfo] = [
        WoodpeckerCardInfo(step: 0, isGraduated: false, easeFactor: 2.5, streak: 0, interval: 0, hasBeenPresented: false),
        WoodpeckerCardInfo(step: 1, isGraduated: false, easeFactor: 2.5, streak: 0, interval: 0, hasBeenPresented: false),
        WoodpeckerCardInfo(step: 2, isGraduated: false, easeFactor: 2.5, streak: 0, interval: 0, hasBeenPresented: false)
    ]
    //They are named with a code B = Box, G = user Grade, the number following the letters indicate their values.
    func testB0G0() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[0], userGrade: .wrongHard, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.stay)
    }
    
    func testB0G1() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[0], userGrade: .wrong, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.stay)
    }
    
    func testB0G2() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[0], userGrade: .correct, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.foward)
    }

    func testB0G3() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[0], userGrade: .correctEasy, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.graduate)
    }
    
    func testB1G0() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[1], userGrade: .wrongHard, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.back)
    }
    
    func testB1G1() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[1], userGrade: .wrong, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.stay)
    }
    
    func testB1G2() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[1], userGrade: .correct, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.foward)
    }
    
    func testB1G3() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[1], userGrade: .correctEasy, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.graduate)
    }
    
    func testB2G0() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[2], userGrade: .wrongHard, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.back)
    }
    
    func testB2G1() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[2], userGrade: .wrong, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.stay)
    }
    
    func testB2G2() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[2], userGrade: .correct, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.stay)
    }
    
    func testB2G3() throws {
        let destiny = try Woodpecker.stepper(cardInfo: cards[2], userGrade: .correctEasy, numberOfSteps: 3)
        XCTAssertEqual(destiny, CardDestiny.graduate)
    }
    
    func testNegativeSteps() {
        XCTAssertThrowsError(try Woodpecker.stepper(cardInfo: WoodpeckerCardInfo(step: -1, isGraduated: false, easeFactor: 2.5, streak: 0, interval: 0, hasBeenPresented: false), userGrade: .correctEasy, numberOfSteps: 3))
    }
    
    func testNotEnoughSteps() {
        XCTAssertThrowsError(try Woodpecker.stepper(cardInfo: WoodpeckerCardInfo(step: 0, isGraduated: false, easeFactor: 2.5, streak: 0, interval: 0, hasBeenPresented: false), userGrade: .correctEasy, numberOfSteps: 0))
    }
    
}
