//
//  Project_BirdUITests.swift
//  Project-BirdUITests
//
//  Created by Gabriel Ferreira de Carvalho on 21/09/22.
//

import XCTest

final class Project_BirdUITests: XCTestCase {

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.buttons["Adicionar"].tap()
        
        XCTAssertTrue(app.buttons["Cancelar"].exists)
        
        app.buttons["Cancelar"].tap()
        
        XCTAssertFalse(app.buttons["Cancelar"].exists)
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
