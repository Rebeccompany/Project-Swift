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
        
        sut = NewCollectionViewModel(
            collectionRepository: collectionRepository,
            dateHandler: dateHandlerMock,
            idGenerator: uuidHandlerMock
        )
        sut.startUp()
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
        sut.currentSelectedIcon = IconNames.book
        try sut.createCollection()
        
        let containsNewCollection = collectionRepository.collections.contains(where: {
            $0.id == uuidHandlerMock.lastCreatedID
        })
        
        XCTAssertTrue(containsNewCollection)   
    }
    
    func testCreateCollectionError() throws {
        sut.collectionName = "Coleção"
        sut.currentSelectedIcon = IconNames.book
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
        sut.currentSelectedIcon = IconNames.book
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)    
    }
    
    func testCanSubmitBindingErrorNoName() {
        let expectation = expectation(description: "Can submit binding")
        sut.currentSelectedIcon = IconNames.book
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    func testCanSubmitBindingSuccessfullyNoColor() {
        let expectation = expectation(description: "Can submit binding")
        sut.collectionName = "Name"
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
        sut = NewCollectionViewModel(collectionRepository: collectionRepository, dateHandler: dateHandlerMock, idGenerator: uuidHandlerMock, editingCollection: collectionRepository.collections[0])
        
        XCTAssertEqual(collectionRepository.collections[0].name, "Matemática Básica")
        
        sut.collectionName = "Matemática II"
        try sut.editCollection()
        
        XCTAssertEqual(collectionRepository.collections[0].name, "Matemática II")
    }
    
    func testEditColorCollectionSuccessfuly() throws {
        sut = NewCollectionViewModel(collectionRepository: collectionRepository, dateHandler: dateHandlerMock, idGenerator: uuidHandlerMock, editingCollection: collectionRepository.collections[0])
        
        XCTAssertEqual(collectionRepository.collections[0].icon, IconNames.book)
        
        sut.currentSelectedIcon = IconNames.pencil
        try sut.editCollection()
        
        XCTAssertEqual(collectionRepository.collections[0].icon, IconNames.pencil)
    }
    
    func testEditCollectionError() throws {
        sut = NewCollectionViewModel(collectionRepository: collectionRepository, dateHandler: dateHandlerMock, idGenerator: uuidHandlerMock, editingCollection: collectionRepository.collections[0])
        
        XCTAssertEqual(collectionRepository.collections[0].icon, .book)
        
        collectionRepository.shouldThrowError = true
        sut.currentSelectedIcon = .pencil
        
        XCTAssertThrowsError(try sut.editCollection())
        
        XCTAssertNotEqual(collectionRepository.collections[0].icon, .pencil)
        XCTAssertEqual(collectionRepository.collections[0].icon, .book)
    }
    
    func testDeleteCollectionSuccessfully() throws {
        sut = NewCollectionViewModel(collectionRepository: collectionRepository, dateHandler: dateHandlerMock, idGenerator: uuidHandlerMock, editingCollection: collectionRepository.collections[0])
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsCollection)
        
        try sut.deleteCollection()
        
        let deletedCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedCollection)
    }
    
    func testDeleteCollectionError() throws {
        sut = NewCollectionViewModel(collectionRepository: collectionRepository, dateHandler: dateHandlerMock, idGenerator: uuidHandlerMock, editingCollection: collectionRepository.collections[0])
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsCollection)
        
        collectionRepository.shouldThrowError = true
        
        XCTAssertThrowsError(try sut.deleteCollection())
        
        let deletedCollection = collectionRepository.collections.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(deletedCollection)
        
    }
}
