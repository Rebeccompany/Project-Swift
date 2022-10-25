//
//  StoreFeatureTests.swift
//  
//
//  Created by Rebecca Mello on 25/10/22.
//

import Foundation

import XCTest
@testable import StoreFeature
import Puffins

final class StoreFeatureTests: XCTestCase {
    var sut: StoreViewModel!
    var externalDeckRepository: ExternalDeckServiceMock!
    
    override func setUp() {
        externalDeckRepository = ExternalDeckServiceMock()
        sut = StoreViewModel()
        sut.startup()
    }
    
    override func tearDown() {
        sut = nil
        externalDeckRepository = nil
    }
    
    func testStartUp() throws {
        let deckExpectation = expectation(description: "Connection with External Deck repository")
        
        sut.$sections
            .sink { [unowned self] sections in
                XCTAssertEqual(sections, externalDeckRepository.feed)
                deckExpectation.fulfill()
            }
        wait(for: [deckExpectation], timeout: 1)
    }
}
