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
import Habitat
import Combine

//TODO: Delete Deck

final class ContentViewModelTests: XCTestCase {
    
    var sut: ContentViewModel!
    var deckRepositoryMock: DeckRepositoryMock!
    var displayCacherMock: DisplayCacher!
    var localStorageMock: LocalStorageMock!
    var collectionRepositoryMock: CollectionRepositoryMock!
    var cancelables: Set<AnyCancellable>!

    override func setUp() {
        deckRepositoryMock = DeckRepositoryMock()
        collectionRepositoryMock = CollectionRepositoryMock()
        localStorageMock = LocalStorageMock()
        displayCacherMock = DisplayCacher(localStorage: localStorageMock)
        setupHabitatForIsolatedTesting(deckRepository: deckRepositoryMock, collectionRepository: collectionRepositoryMock, displayCacher: displayCacherMock)
        sut = ContentViewModel()
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
    
    func testStartupDetail() {
        displayCacherMock.saveDetailType(detailType: .table)
        XCTAssertEqual(sut.detailType, .grid)
        
        sut.startup()
        
        XCTAssertEqual(.table, sut.detailType)
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
        XCTAssertEqual("Todos os Baralhos", sut.detailTitle)
    }
    
    func testDetailNameForSingleCollection() {
        sut.sidebarSelection = .decksFromCollection(collectionRepositoryMock.collections[0])
        XCTAssertEqual(collectionRepositoryMock.collections[0].name, sut.detailTitle)
    }
    
    func testDeleteSingleCollectionSuccessifully() throws {
        
        let collectionToBeDeleted = collectionRepositoryMock.collections[0]
        try sut.deleteCollection(collectionToBeDeleted)
        
        let doesContainCollection = collectionRepositoryMock.collections.contains { $0.id == collectionToBeDeleted.id }
        
        XCTAssertFalse(doesContainCollection)
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
    
    func testSelectedCollectionWhenSidebarIsAllDecks() {
        sut.sidebarSelection = .allDecks
        
        XCTAssertNil(sut.selectedCollection)
    }
    
    func testSelectedCollectionWhenSidebarIsACollection() {
        sut.sidebarSelection = .decksFromCollection(collectionRepositoryMock.collections[0])
        
        XCTAssertEqual(collectionRepositoryMock.collections[0], sut.selectedCollection)
    }
    
    func testEditDeckSuccessfully() {
        let deck = deckRepositoryMock.decks[0]
        sut.selection.insert(deck.id)
        
        XCTAssertEqual(sut.selection.count, 1)
        
        sut.editDeck()
        
        XCTAssertEqual(sut.editingDeck, deck)
    }

    func testEditDeckWithWrongSelection() {
        sut.selection = .init()
        
        XCTAssertNil(sut.editingDeck)
        
        sut.editDeck()
        
        XCTAssertNil(sut.editingDeck)
    }
    
    func testEditDeckWithWrongDeck() {
        let deck = Deck(id: UUID.init(), name: "deck", icon: "flame", color: .beigeBrown, collectionId: UUID.init(), cardsIds: [])
        
        sut.selection.insert(deck.id)
        sut.editDeck()
        
        XCTAssertNil(sut.editingDeck)
    }
    
    func testDeckStatusPresentationTrue() {
        sut.editingDeck = deckRepositoryMock.decks[0]
        sut.selection.insert(sut.editingDeck!.id)
        
        sut .didDeckPresentationStatusChanged(true)
        
        XCTAssertEqual(sut.editingDeck, deckRepositoryMock.decks.first)
        XCTAssertEqual(sut.selection.first, deckRepositoryMock.decks.first?.id)
    }
    
    func testDeckPresentationFalse() {
        sut.editingDeck = deckRepositoryMock.decks[0]
        sut.selection.insert(sut.editingDeck!.id)
        
        sut.didDeckPresentationStatusChanged(false)
        
        XCTAssertNil(sut.editingDeck)
    }
    
    func testCollectionStatusPresentationTrue() {
        sut.editingCollection = collectionRepositoryMock.collections.first
        
        sut.didCollectionPresentationStatusChanged(true)
        
        XCTAssertEqual(sut.editingCollection, collectionRepositoryMock.collections.first)
    }
    
    func testCollectionStatusPresentationFalse() {
        sut.editingCollection = collectionRepositoryMock.collections.first
        
        sut.didCollectionPresentationStatusChanged(false)
        
        XCTAssertNil(sut.editingCollection)
    }
    
    func testCreateDeck() {
        sut.editingDeck = deckRepositoryMock.decks[0]
        
        sut.createDecks()
        
        XCTAssertNil(sut.editingDeck)
    }
    
    func testDeleteDeckSuccessifully() throws {
        sut.selection = Set(Array(deckRepositoryMock.decks[0...2]).map(\.id))
        XCTAssertEqual(4, deckRepositoryMock.decks.count)
        
        try sut.deleteDecks()
        
        XCTAssertEqual(1, deckRepositoryMock.decks.count)
    }
    
    func testDeleteDeckFailed() throws {
        
        sut.selection.insert(UUID())
        
        XCTAssertThrowsError(try sut.deleteDecks())
    }
    
    func testChangeDetailType() throws {
        XCTAssertEqual(sut.detailType, .grid)
        let current = displayCacherMock.getCurrentDetailType()
        XCTAssertNil(current)
        sut.changeDetailType(for: .table)
        XCTAssertEqual(sut.detailType, .table)
        XCTAssertEqual(.table, displayCacherMock.getCurrentDetailType())
    }
}
