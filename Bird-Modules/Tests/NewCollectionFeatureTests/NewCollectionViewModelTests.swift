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
            colors: CollectionColor.allCases,
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
    
    func testCreateCollectionSuccessfully() {
        sut.collectionName = "Coleção"
        sut.currentSelectedColor = CollectionColor.red
        sut.createCollection()
        
        let containsNewCollection = collectionRepository.collections.contains(where: {
            $0.id == uuidHandlerMock.lastCreatedID
        })
        
        XCTAssertTrue(containsNewCollection)   
    }
    
    func testCreateCollectionError() {
        sut.collectionName = "Coleção"
        sut.currentSelectedColor = CollectionColor.red
        collectionRepository.shouldThrowError = true
        sut.createCollection()
        
        let containsNewCollection = collectionRepository.collections.contains(where: {
            $0.id == uuidHandlerMock.lastCreatedID
        })
        
        XCTAssertTrue(!containsNewCollection)
    }
    
    func testCanSubmitBindingSuccessfully() {
        let expectation = expectation(description: "Can submit binding")
        sut.collectionName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)    
    }
    
    func testCanSubmitBindingErrorNoName() {
        let expectation = expectation(description: "Can submit binding")
        sut.currentSelectedColor = CollectionColor.red
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    func testCanSubmitBindingSuccessfullyNoColor() {
        let expectation = expectation(description: "Can submit binding")
        sut.collectionName = "Name"
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoNameNoColor() {
        let expectation = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 1)
    }
}
