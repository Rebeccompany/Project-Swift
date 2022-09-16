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
        let expectation = expectation(description: "Connection with repository")
        
        sut.$collections
            .sink {[unowned self] collections in
                XCTAssertEqual(collections, collectionRepositoryMock.collections)
                expectation.fulfill()
            }
            .store(in: &cancelables)
        
        wait(for: [expectation], timeout: 1)
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
