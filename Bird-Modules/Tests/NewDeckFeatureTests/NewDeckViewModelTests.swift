//
//  NewDeckViewModelTests 2.swift
//  
//
//  Created by Rebecca Mello on 08/09/22.
//

import XCTest
@testable import NewDeckFeature
import Storage
import Models
import HummingBird
import Combine
import Utils
import Habitat

@MainActor
class NewDeckViewModelTests: XCTestCase {

    var sut: NewDeckViewModel!
    var deckRepository: DeckRepositoryMock!
    var dateHandlerMock: DateHandlerMock!
    var uuidHandler: UUIDHandlerMock!
    var cancellables: Set<AnyCancellable>!
    var collectionRepository: CollectionRepositoryMock!
    
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        dateHandlerMock = DateHandlerMock()
        collectionRepository = CollectionRepositoryMock()
        uuidHandler = UUIDHandlerMock()
        cancellables = .init()
        
        setupHabitatForIsolatedTesting(deckRepository: deckRepository, collectionRepository: collectionRepository, dateHandler: dateHandlerMock, uuidGenerator: uuidHandler)
        sut = NewDeckViewModel()
        
        sut.startUp(editingDeck: nil)
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
        collectionRepository = nil
        dateHandlerMock = nil
        uuidHandler = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
    }
    
    func testCreateDeckSuccessfully() throws {
        try sut.createDeck(collection: nil)
        
        let containsNewDeck = deckRepository.decks.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsNewDeck)
    }
    
    func testCreateDeckWithCollectionSucessfully() throws {
        try sut.createDeck(collection: collectionRepository.collections[0])
        
        let collectionsContainsNewDeck = collectionRepository.collections[0].decksIds.contains(uuidHandler.lastCreatedID!)
        
        let newDeck = deckRepository.decks.first(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertNotNil(newDeck)
        XCTAssertTrue(collectionsContainsNewDeck)
        XCTAssertEqual(newDeck?.collectionId, collectionRepository.collections[0].id)
    }
    
    func testCreateDeckError() throws {
        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createDeck(collection: nil))
        
        let containsNewDeck = deckRepository.decks.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertFalse(containsNewDeck)
    }
    
    func testCanSubmitBindingSuccessfully() {
        let expectations = expectation(description: "Can submit binding")
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.atom
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoName() {
        let expectations = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColor() {
        let expectations = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoIcon() {
        let expectations = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoNameAndColor() {
        let expectations = expectation(description: "Can submit binding")
        sut.currentSelectedIcon = IconNames.atom
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoNameAndIcon() {
        let expectations = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColorAndIcon() {
        let expectations = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoNameColorAndIcon() {
        let expectations = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testEditDeckName() throws {
        XCTAssertEqual(deckRepository.decks[0].name, "Programação Swift")

        sut.deckName = "New name"
        try sut.editDeck(editingDeck: deckRepository.decks[0])
        
        XCTAssertEqual(deckRepository.decks[0].name, "New name")
    }
    
    func testEditDeckColor() throws {
        XCTAssertEqual(deckRepository.decks[0].color, .red)

        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editDeck(editingDeck: deckRepository.decks[0])
        
        XCTAssertEqual(deckRepository.decks[0].color, .darkBlue)
    }
    
    func testEditDeckIcon() throws {
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.atom.rawValue)
        
        sut.currentSelectedIcon = IconNames.books
        try sut.editDeck(editingDeck: deckRepository.decks[0])
        
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.books.rawValue)
    }
    
    func testEditDeckError() throws {
        XCTAssertEqual(deckRepository.decks[0].color, .red)
        
        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        XCTAssertThrowsError(try sut.editDeck(editingDeck: deckRepository.decks[0]))
        
        XCTAssertNotEqual(deckRepository.decks[0].color, CollectionColor.darkBlue)
    }
    
    func testDeleteDeckSuccessfully() throws {
        let id = UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2")
        
        let containsDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsDeck)

        try sut.deleteDeck(editingDeck: deckRepository.decks[0])

        let deletedDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedDeck)
    }
    
    func testDeleteDeckError() throws {
        let id = UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2")
        
        let containsDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsDeck)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.deleteDeck(editingDeck: deckRepository.decks[0]))

        let deletedDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(deletedDeck)
    }

}
