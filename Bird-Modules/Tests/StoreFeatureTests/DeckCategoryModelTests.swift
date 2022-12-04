//
//  DeckCategoryModelTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/12/22.
//

import XCTest
@testable import StoreFeature
import Habitat
import Puffins
import Combine
import Models

final class DeckCategoryModelTests: XCTestCase {

    var sut: DeckCategoryModel!
    var deckServiceMock: ExternalDeckServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        deckServiceMock = .init()
        setupHabitatForIsolatedTesting(externalDeckService: deckServiceMock)
        sut = .init()
        cancellables = .init()
    }
    
    override func tearDown() {
        sut = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
    }

    func testStartUpSuccess() {
        let expectation = expectation(description: "load decks")
        
        sut.startUp(with: .stem)
        
        sut.$decks
            .sink {[unowned self] decks in
                XCTAssertFalse(decks.isEmpty)
                XCTAssertTrue(self.sut.shouldLoadMore)
                XCTAssertEqual(self.deckServiceMock.lastPageCalled, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testStartUpFailed() {
        let expectation = expectation(description: "load decks")
        
        deckServiceMock.error = URLError(.badServerResponse)
        deckServiceMock.shouldError = true
        
        sut.startUp(with: .stem)
        
        sut.$decks
            .sink {[unowned self] decks in
                XCTAssertTrue(decks.isEmpty)
                XCTAssertEqual(self.sut.viewState, .error)
                XCTAssertEqual(self.deckServiceMock.lastPageCalled, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadMoreDecksSuccess() {
        let expectation = expectation(description: "load decks")
        
        sut.startUp(with: .stem)
        sut.loadMoreDecks(from: .stem)
        
        sut.$decks
            .sink {[unowned self] decks in
                XCTAssertEqual(decks.count, 60)
                XCTAssertTrue(self.sut.shouldLoadMore)
                XCTAssertEqual(self.deckServiceMock.lastPageCalled, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadMoreDecksFailed() {
        let expectation = expectation(description: "load decks")
        
        sut.startUp(with: .stem)
        
        deckServiceMock.error = URLError(.badServerResponse)
        deckServiceMock.shouldError = true
        
        sut.loadMoreDecks(from: .stem)
        
        sut.$decks
            .sink {[unowned self] decks in
                XCTAssertEqual(decks.count, 30)
                XCTAssertEqual(self.sut.viewState, .error)
                XCTAssertTrue(self.sut.shouldLoadMore)
                XCTAssertEqual(self.deckServiceMock.lastPageCalled, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
