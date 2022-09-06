//
//  StudyViewModelTests.swift
//  
//
//  Created by Marcos Chevis on 06/09/22.
//

import XCTest
@testable import StudyFeature
import Storage
import Models

class StudyViewModelTests: XCTestCase {
    
    var sut: StudyViewModel!
    var deckRepository: DeckRepository!
    var deck: Deck!

    override func setUpWithError() throws {
        deckRepository = DeckRepository
        sut = .init(deckRepository: , sessionCacher: <#T##SessionCacher#>, deck: <#T##Deck#>)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
