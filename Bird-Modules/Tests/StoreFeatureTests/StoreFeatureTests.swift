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
import StoreState

final class StoreFeatureTests: XCTestCase {
    var sut: FeedInteractor!
    var externalDeckRepository: ExternalDeckServiceMock!
    var cancelables: Set<AnyCancellable>!

    override func setUp() {
        externalDeckRepository = ExternalDeckServiceMock()
        setupHabitatForIsolatedTesting(externalDeckService: externalDeckRepository)
        sut = FeedInteractor()
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
    
    func testStartUpSucessfully() throws {
        let deckExpectation = expectation(description: "Connection with External Deck repository")
        
        var initialState = FeedState()
        
        sut
            .reduce(&initialState, action: .loadFeed)
            .sink { _ in
                
            } receiveValue: {[unowned self] newState in
                XCTAssertEqual(newState.viewState, .loaded)
                XCTAssertEqual(newState.sections, self.externalDeckRepository.feed)
                deckExpectation.fulfill()
            }
            .store(in: &cancelables)

        
        XCTAssertEqual(initialState.viewState, .loading)
        XCTAssertTrue(initialState.sections.isEmpty)
        wait(for: [deckExpectation], timeout: 1)
    }
    
    func testStartUpError() throws {
        let deckExpectation = expectation(description: "Connection with External Deck repository")
        externalDeckRepository.shouldError = true
        var newState = FeedState()

        sut
            .reduce(&newState, action: .loadFeed)
            .sink { newState in
                XCTAssertEqual(newState.viewState, .error)
                deckExpectation.fulfill()
            }
            .store(in: &cancelables)

        
        wait(for: [deckExpectation], timeout: 1)
    }
}
