//
//  SearchModelTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/12/22.
//

import XCTest
@testable import StoreFeature
import Habitat
import Puffins
import Combine

final class SearchModelTests: XCTestCase {

    var sut: SearchDeckModel!
    var deckServiceMock: ExternalDeckServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        deckServiceMock = .init()
        setupHabitatForIsolatedTesting(externalDeckService: deckServiceMock)
        sut = .init()
        cancellables = .init()
        sut.startUp()
    }
    
    override func tearDown() {
        sut = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
    }
    
    func testSearchTextSuccess() {
        let expectation = expectation(description: "decks searchs")
        var callCount = 0
        sut.searchText = "some string"
        
        sut.$decks
            .sink {[unowned self] decks in
                if callCount > 0 {
                    XCTAssertFalse(decks.isEmpty)
                    XCTAssertEqual(self.sut.viewState, .loaded)
                    XCTAssertTrue(self.sut.shouldLoadMore)
                    XCTAssertEqual(self.deckServiceMock.lastPageCalled, 0)
                    expectation.fulfill()
                } else {
                    callCount += 1
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchTextRemoveDuplicate() {
        let expectation = expectation(description: "decks searchs")
        sut.searchText = ""
        
        sut.$decks
            .sink {[unowned self] decks in
                XCTAssertTrue(decks.isEmpty)
                XCTAssertEqual(self.sut.viewState, .loaded)
                XCTAssertFalse(self.sut.shouldLoadMore)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSearchTextFailed() {
        let expectation = expectation(description: "decks searchs")
        var callCount = 0
        sut.searchText = "some string"
        deckServiceMock.error = URLError(.badServerResponse)
        deckServiceMock.shouldError = true
        
        sut.$viewState
            .sink { state in
                if callCount > 1 {
                    XCTAssertEqual(state, .error)
                    expectation.fulfill()
                } else {
                    callCount += 1
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    func testLoadMoreDecksSuccess() {
        let expectation = expectation(description: "decks searchs")
        var callCount = 0
        
        sut.loadMoreDecks()
        
        sut.$decks
            .sink {[unowned self] decks in
                if callCount > 0 {
                    XCTAssertFalse(decks.isEmpty)
                    XCTAssertEqual(self.sut.viewState, .loaded)
                    XCTAssertTrue(self.sut.shouldLoadMore)
                    XCTAssertEqual(self.deckServiceMock.lastPageCalled, 1)
                    expectation.fulfill()
                } else {
                    callCount += 1
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadMoreDeckFailed() {
        let expectation = expectation(description: "decks searchs")
        var callCount = 0
        
        deckServiceMock.error = URLError(.badServerResponse)
        deckServiceMock.shouldError = true
        
        sut.loadMoreDecks()
        
        sut.$viewState
            .sink {[unowned self] state in
                if callCount > 0 {
                    XCTAssertEqual(state, .error)
                    XCTAssertEqual(self.deckServiceMock.lastPageCalled, 1)
                    expectation.fulfill()
                } else {
                    callCount += 1
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testReloadDecksSuccess() {
        let expectation = self.expectation(description: "decks searchs")
        var callCount = 0
        
        sut.reloadDecks()
        
        XCTAssertTrue(sut.decks.isEmpty)
        XCTAssertEqual(sut.viewState, .loading)
        
        sut.$decks
            .sink {[unowned self] decks in
                if callCount > 0 {
                    XCTAssertFalse(decks.isEmpty)
                    XCTAssertTrue(self.sut.shouldLoadMore)
                    XCTAssertEqual(self.deckServiceMock.lastPageCalled, 0)
                    expectation.fulfill()
                } else {
                    callCount += 1
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testReLoadDeckFailed() {
        let expectation = expectation(description: "decks searchs")
        var callCount = 0
        
        deckServiceMock.error = URLError(.badServerResponse)
        deckServiceMock.shouldError = true
        
        sut.reloadDecks()
        
        sut.$viewState
            .sink {[unowned self] state in
                if callCount > 0 {
                    XCTAssertEqual(state, .error)
                    XCTAssertEqual(self.deckServiceMock.lastPageCalled, 0)
                    expectation.fulfill()
                } else {
                    callCount += 1
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
