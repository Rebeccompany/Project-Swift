//
//  Project_BirdUITestsLaunchTests.swift
//  Project-BirdUITests
//
//  Created by Gabriel Ferreira de Carvalho on 21/09/22.
//

import XCTest

final class Project_BirdUITestsLaunchTests: XCTestCase {

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
