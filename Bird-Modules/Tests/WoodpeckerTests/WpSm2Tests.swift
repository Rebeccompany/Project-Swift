//
//  WpSm2Tests.swift
//  
//
//  Created by Marcos Chevis on 18/08/22.
//

import XCTest
@testable import Woodpecker
import Models

final class WpSm2Tests: XCTestCase {

    //UserGrade == .wrongHard
    func testNewCardBackToLearning() {
        let card0 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.5, streak: 0, interval: 0)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: false, easeFactor: 1.7, streak: 0, interval: 0)

        let newCard = try! Woodpecker.wpSm2(card0, userGrade: .wrongHard)
        XCTAssertEqual(newCard, card1)
    }
    
    //Ug == userGrade, 1 == .wrong
    func testNewCardUg1() {
        let card0 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.5, streak: 0, interval: 0)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.0, streak: 0, interval: 1)
        let newCard = try! Woodpecker.wpSm2(card0, userGrade: .wrong)
        XCTAssertEqual(newCard, card1)
    }
    
    func testNewCardUg2() {
        let card0 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.5, streak: 0, interval: 0)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.5, streak: 1, interval: 1)
        let newCard = try! Woodpecker.wpSm2(card0, userGrade: .correct)
        XCTAssertEqual(newCard, card1)
    }
    
    func testNewCardUg3() {
        let card0 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.5, streak: 0, interval: 0)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.6, streak: 1, interval: 1)
        let newCard = try! Woodpecker.wpSm2(card0, userGrade: .correctEasy)
        XCTAssertEqual(newCard, card1)
    }
    
    func testStreak1() {
        let card0 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.6, streak: 1, interval: 1)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.7, streak: 2, interval: 6)
        let newCard = try! Woodpecker.wpSm2(card0, userGrade: .correctEasy)
        XCTAssertEqual(newCard, card1)
    }
    
    func testStreakGreater1() {
        let card0 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.8, streak: 2, interval: 6)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 2.9, streak: 3, interval: 17)
        let newCard = try! Woodpecker.wpSm2(card0, userGrade: .correctEasy)
        XCTAssertEqual(newCard, card1)
    }
    
    func testLowestEaseFactor() {
        let card0 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 1.7, streak: 0, interval: 1)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: true, easeFactor: 1.3, streak: 0, interval: 1)
        let newCard = try! Woodpecker.wpSm2(card0, userGrade: .wrong)
        XCTAssertEqual(newCard, card1)
    }

    func testErrors() {
        let card0 = WoodpeckerCardInfo(step: 1, isGraduated: true, easeFactor: 1.7, streak: 0, interval: 1)
        let card1 = WoodpeckerCardInfo(step: 0, isGraduated: false, easeFactor: 1.3, streak: 0, interval: 1)
        XCTAssertThrowsError(try Woodpecker.wpSm2(card0, userGrade: .wrong))
        XCTAssertThrowsError(try Woodpecker.wpSm2(card1, userGrade: .wrong))
    }
}
