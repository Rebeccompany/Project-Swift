//
//  ContentViewModelTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/22.
//

import XCTest
@testable import AppFeature
import Models
import Storage
import Combine

//TODO: Deck listener React to sidebar
//TODO: Update Deck
//TODO: Delete Deck
//TODO: Create Deck

final class ContentViewModelTests: XCTestCase {
    
    var sut: ContentViewModel!
    var deckRepositoryMock: DeckRepositoryMock!
    var collectionRepositoryMock: CollectionRepositoryMock!
    var cancelables: Set<AnyCancellable>!

    override func setUp() {
        deckRepositoryMock = DeckRepositoryMock()
        collectionRepositoryMock = CollectionRepositoryMock()
        sut = ContentViewModel(
            collectionRepository: collectionRepositoryMock,
            deckRepository: deckRepositoryMock
        )
        cancelables = Set<AnyCancellable>()
        sut.startup()
    }
    
    override func tearDown() {
        cancelables.forEach { cancellable in
            cancellable.cancel()
        }
        
        sut = nil
        collectionRepositoryMock = nil
        deckRepositoryMock = nil
        cancelables = nil
    }
    
    func testStartup() {
        let collectionExpectation = expectation(description: "Connection with collection repository")
        let deckExpectation = expectation(description: "Connection with Deck repository")
        
        sut.$collections
            .sink {[unowned self] collections in
                XCTAssertEqual(collections, collectionRepositoryMock.collections)
                collectionExpectation.fulfill()
            }
            .store(in: &cancelables)
        
        sut.$decks
            .sink { [unowned self] decks in
                XCTAssertEqual(decks, self.deckRepositoryMock.decks)
                XCTAssertEqual(self.sut.sidebarSelection, .allDecks)
                deckExpectation.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [collectionExpectation, deckExpectation], timeout: 1)
    }
    
    func testDeckReactionToSidebarSelection() {
        let expectation = expectation(description: "Receive the correct decks")
        
        sut.sidebarSelection = .decksFromCollection(collectionRepositoryMock.collections[0])
        sut.$decks
            .sink {[unowned self] decks in
                XCTAssertEqual(Array(self.deckRepositoryMock.decks[1...2]), decks)
                expectation.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testAllDecksFilteredBySearchText() {
        let expectation = expectation(description: "Receive the correct decks")
        
        let expectedResults = deckRepositoryMock.decks.enumerated().filter { $0.offset != 2 }.map(\.element)
        sut.sidebarSelection = .allDecks
        sut.searchText = "Swift"
        
        sut.$decks
            .sink { decks in
                XCTAssertEqual(decks, expectedResults)
                expectation.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testCollectionDecksFilteredBySearchText() {
        let expectation = expectation(description: "Receive the correct decks")
        let expectedResults = [deckRepositoryMock.decks[1]]
        sut.sidebarSelection = .decksFromCollection(collectionRepositoryMock.collections[0])
        sut.searchText = "Swift"
        
        sut.$decks
            .sink { decks in
                XCTAssertEqual(expectedResults, decks)
                expectation.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDetailNameForAllDecks() {
        sut.sidebarSelection = .allDecks
        XCTAssertEqual("Todas as coleções", sut.detailTitle)
    }
    
    func testDetailNameForSingleCollection() {
        sut.sidebarSelection = .decksFromCollection(collectionRepositoryMock.collections[0])
        XCTAssertEqual(collectionRepositoryMock.collections[0].name, sut.detailTitle)
    }
    
    func testDeleteCollectionSuccessifully() throws {
        let indexSet = IndexSet([0])
        let collectionToBeDeleted = collectionRepositoryMock.collections[0]
        
        try sut.deleteCollection(at: indexSet)
        
        let doesContainCollection = collectionRepositoryMock.collections.contains { $0.id == collectionToBeDeleted.id }
        
        XCTAssertFalse(doesContainCollection)
    }
    
    func testEditCollection() {
        let collection = collectionRepositoryMock.collections[0]
        
        sut.editCollection(collection)
        
        XCTAssertEqual(collection, sut.editingCollection)
    }
    
    func testCreateCollection() {
        sut.editingCollection = collectionRepositoryMock.collections[0]
        
        sut.createCollection()
        
        XCTAssertNil(sut.editingCollection)
    }

}
