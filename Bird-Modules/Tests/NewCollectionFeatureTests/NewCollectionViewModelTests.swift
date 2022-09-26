//
//  NewCollectionViewModelTests.swift
//  
//
//  Created by Caroline Taus on 08/09/22.
//

import XCTest
@testable import NewCollectionFeature
import Storage
import Combine
import Models
import Habitat

@MainActor
class NewCollectionViewModelTests: XCTestCase {

    var sut: NewCollectionViewModel!
    var collectionRepository: CollectionRepositoryMock!
    var dateHandlerMock: DateHandlerMock!
    var uuidHandlerMock: UUIDHandlerMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        collectionRepository = CollectionRepositoryMock()
        cancellables = .init()
        dateHandlerMock = DateHandlerMock()
        uuidHandlerMock = UUIDHandlerMock()
        
        setupHabitatForIsolatedTesting(collectionRepository: collectionRepository, dateHandler: dateHandlerMock, uuidGenerator: uuidHandlerMock)
        sut = NewCollectionViewModel()
        sut.startUp(editingCollection: nil)
    }
    
    override func tearDown() {
        sut = nil
        collectionRepository = nil
        dateHandlerMock = nil
        uuidHandlerMock = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
    }
    
    func testCreateCollectionSuccessfully() throws {
        sut.collectionName = "Coleção"
        sut.currentSelectedIcon = IconNames.atom
        try sut.createCollection()
        
        let containsNewCollection = collectionRepository.collections.contains(where: {
            $0.id == uuidHandlerMock.lastCreatedID
        })
        
        XCTAssertTrue(containsNewCollection)   
    }
    
    func testCreateCollectionError() throws {
        sut.collectionName = "Coleção"
        sut.currentSelectedIcon = IconNames.atom
        collectionRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createCollection())
        
        let containsNewCollection = collectionRepository.collections.contains(where: {
            $0.id == uuidHandlerMock.lastCreatedID
        })
        
        XCTAssertFalse(containsNewCollection)
    }
    
    func testCanSubmitBindingSuccessfully() {
        let expectation = expectation(description: "Can submit binding")
        sut.collectionName = "Name"
        sut.currentSelectedIcon = IconNames.atom
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)    
    }
    
    func testCanSubmitBindingErrorNoName() {
        let expectation = expectation(description: "Can submit binding")
        sut.currentSelectedIcon = IconNames.atom
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    func testCanSubmitBindingSuccessfullyNoIcon() {
        let expectation = expectation(description: "Can submit binding")
        sut.collectionName = "Name"
        sut.currentSelectedIcon = nil
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoNameNoColor() {
        let expectation = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testEditNameCollectionSuccessfuly() throws {
        
        
        XCTAssertEqual(collectionRepository.collections[0].name, "Matemática Básica")
        
        sut.collectionName = "Matemática II"
        try sut.editCollection(editingCollection: collectionRepository.collections[0])
        
        XCTAssertEqual(collectionRepository.collections[0].name, "Matemática II")
    }
    
    func testEditColorCollectionSuccessfuly() throws {
        
        
        XCTAssertEqual(collectionRepository.collections[0].icon, IconNames.atom)
        
        sut.currentSelectedIcon = IconNames.books
        try sut.editCollection(editingCollection: collectionRepository.collections[0])
        
        XCTAssertEqual(collectionRepository.collections[0].icon, IconNames.books)
    }
    
    func testEditCollectionError() throws {
        
        XCTAssertEqual(collectionRepository.collections[0].icon, .atom)
        
        collectionRepository.shouldThrowError = true
        sut.currentSelectedIcon = .books
        
        XCTAssertThrowsError(try sut.editCollection(editingCollection: collectionRepository.collections[0]))
        
        XCTAssertNotEqual(collectionRepository.collections[0].icon, .books)
        XCTAssertEqual(collectionRepository.collections[0].icon, .atom)
    }
    
    func testDeleteCollectionSuccessfully() throws {
        
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsCollection)
        
        try sut.deleteCollection(editingCollection: collectionRepository.collections[0])
        
        let deletedCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedCollection)
    }
    
    func testDeleteCollectionError() throws {
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsCollection)
        
        collectionRepository.shouldThrowError = true
        
        XCTAssertThrowsError(try sut.deleteCollection(editingCollection: collectionRepository.collections[0]))
        
        let deletedCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(deletedCollection)
        
    }
}
