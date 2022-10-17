//
//  Project_BirdUITests.swift
//  Project-BirdUITests
//
//  Created by Gabriel Ferreira de Carvalho on 21/09/22.
//

import XCTest

final class Project_BirdUITests: XCTestCase {
    
    var sut: XCUIApplication!

    override func setUp() {
        sut = .init()
        sut.launchArguments.append("UITEST")
        sut.launch()
    }
    
    override func tearDown() {
        sut = nil
    }

    func testExample() throws {
        sut.buttons["Plus_Deck"].tap()
        
        XCTAssertTrue(sut.buttons["Cancel"].exists)
        
        sut.buttons["Cancel"].tap()
        
        XCTAssertFalse(sut.buttons["Cancel"].exists)
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
