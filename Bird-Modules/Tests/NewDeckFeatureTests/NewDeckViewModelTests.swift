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

class NewDeckViewModelTests: XCTestCase {

    var sut: NewDeckViewModel!
    var deckRepository: DeckRepositoryMock!
    var dateHandlerMock: DateHandlerMock!
    var uuidHandler: UUIDHandlerMock!
    var cancellables: Set<AnyCancellable>!
    
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        dateHandlerMock = DateHandlerMock()
        uuidHandler = UUIDHandlerMock()
        cancellables = .init()
        
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               deckRepository: deckRepository,
                               collectionId: [],
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
        )
        sut.startUp()
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
        dateHandlerMock = nil
        uuidHandler = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
    }
    
    func testCreateDeckSuccessfully() {
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.book
        sut.createDeck()
        
        let containsNewDeck = deckRepository.decks.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsNewDeck)
    }
    
    func testCreateDeckError() {
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.book
        deckRepository.shouldThrowError = true
        sut.createDeck()
        
        let containsNewDeck = deckRepository.decks.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertFalse(containsNewDeck)
    }
    
    func testCanSubmitBindingSuccessfully() {
        let expectations = expectation(description: "Can submit binding")
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.book
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
        sut.currentSelectedIcon = IconNames.book
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
        sut.currentSelectedIcon = IconNames.book
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
        sut.currentSelectedIcon = IconNames.book
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
    
    func testEditDeckName() {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collectionId: [],
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].name, "Programação Swift")

        sut.deckName = "New name"
        sut.editDeck()
        
        XCTAssertEqual(deckRepository.decks[0].name, "New name")
    }
    
    func testEditDeckColor() {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collectionId: [],
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].color, .red)

        sut.currentSelectedColor = CollectionColor.darkBlue
        sut.editDeck()
        
        XCTAssertEqual(deckRepository.decks[0].color, .darkBlue)
    }
    
    func testEditDeckIcon() {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collectionId: [],
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.pencil.rawValue)
        
        sut.currentSelectedIcon = IconNames.book
        sut.editDeck()
        
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.book.rawValue)
    }
    
    func testDeleteDeck() {
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.book
        sut.createDeck()
        
        let initialCount = deckRepository.decks.count
        
        XCTAssertEqual(initialCount, 5)
        
        sut.deleteDeck()
        let updatedCount = deckRepository.decks.count
        
        XCTAssertEqual(updatedCount, 4)
    }

}
