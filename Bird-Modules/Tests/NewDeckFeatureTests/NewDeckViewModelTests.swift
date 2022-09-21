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
        
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               deckRepository: deckRepository,
                               collectionRepository: collectionRepository,
                               collection: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
        )
        sut.startUp()
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
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.atom
        try sut.createDeck()
        
        let containsNewDeck = deckRepository.decks.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsNewDeck)
    }
    
    func testCreateDeckWithCollectionSucessfully() throws {
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.beigeBrown
        sut.currentSelectedIcon = IconNames.brain
        sut.collection = collectionRepository.collections[0]
        try sut.createDeck()
        
        let collectionsContainsNewDeck = collectionRepository.collections[0].decksIds.contains(uuidHandler.lastCreatedID!)
        
        let newDeck = deckRepository.decks.first(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertNotNil(newDeck)
        XCTAssertTrue(collectionsContainsNewDeck)
        XCTAssertEqual(newDeck?.collectionId, collectionRepository.collections[0].id)
    }
    
    func testCreateDeckError() throws {
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.atom
        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createDeck())
        
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
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.atom
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColor() {
        let expectations = expectation(description: "Can submit binding")
        sut.deckName = "Name"
        sut.currentSelectedIcon = IconNames.atom
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoIcon() {
        let expectations = expectation(description: "Can submit binding")
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
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
        sut.currentSelectedColor = CollectionColor.red
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(!canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColorAndIcon() {
        let expectations = expectation(description: "Can submit binding")
        sut.deckName = "Name"
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
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collection: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].name, "Programação Swift")

        sut.deckName = "New name"
        try sut.editDeck()
        
        XCTAssertEqual(deckRepository.decks[0].name, "New name")
    }
    
    func testEditDeckColor() throws {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collection: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].color, .red)

        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editDeck()
        
        XCTAssertEqual(deckRepository.decks[0].color, .darkBlue)
    }
    
    func testEditDeckIcon() throws {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collection: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.atom.rawValue)
        
        sut.currentSelectedIcon = IconNames.books
        try sut.editDeck()
        
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.books.rawValue)
    }
    
    func testEditDeckError() throws {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collection: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].color, .red)
        
        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        XCTAssertThrowsError(try sut.editDeck())
        
        XCTAssertNotEqual(deckRepository.decks[0].color, CollectionColor.darkBlue)
    }
    
    func testDeleteDeckSuccessfully() throws {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collection: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        let id = UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2")
        
        let containsDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsDeck)

        try sut.deleteDeck()

        let deletedDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedDeck)
    }
    
    func testDeleteDeckError() throws {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collection: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        let id = UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2")
        
        let containsDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsDeck)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.deleteDeck())

        let deletedDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(deletedDeck)
    }

}
