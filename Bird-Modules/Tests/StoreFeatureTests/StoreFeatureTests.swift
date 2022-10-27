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
import Habitat
import Combine

final class StoreFeatureTests: XCTestCase {
    var sut: StoreViewModel!
    var externalDeckRepository: ExternalDeckServiceMock!
    var cancelables: Set<AnyCancellable>!

    override func setUp() {
        externalDeckRepository = ExternalDeckServiceMock()
        setupHabitatForIsolatedTesting(externalDeckService: externalDeckRepository)
        sut = StoreViewModel()
        cancelables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancelables.forEach { cancellable in
            cancellable.cancel()
        }
        sut = nil
        externalDeckRepository = nil
        cancelables = nil
    }
    
    func testStartUpLoaded() throws {
        sut.startup()
        let deckExpectation = expectation(description: "Connection with External Deck repository")
        
        sut.$sections
            .sink { [unowned self] sections in
                XCTAssertEqual(sections, externalDeckRepository.feed)
                deckExpectation.fulfill()
            }
            .store(in: &cancelables)
        wait(for: [deckExpectation], timeout: 1)
        XCTAssertEqual(sut.viewState, .loaded)
    }
    
    func testStartUpLoading() throws {
        sut.startup()
        let deckExpectation = expectation(description: "Connection with External Deck repository")
        
        sut.$sections
            .sink { [unowned self] sections in
                XCTAssertEqual(sections, externalDeckRepository.feed)
                deckExpectation.fulfill()
            }
            .store(in: &cancelables)
        wait(for: [deckExpectation], timeout: 4)
        XCTAssertEqual(sut.viewState, .loaded)
    }
    
    func testStartUpError() throws {
        let deckExpectation = expectation(description: "Connection with External Deck repository")
        externalDeckRepository.shouldError = true
        sut.startup()
        
        sut.$sections
            .sink { [] sections in
                XCTAssertEqual(sections, [])
                deckExpectation.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [deckExpectation], timeout: 1)
        XCTAssertEqual(sut.viewState, .error)
    }
}
