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
    
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        dateHandlerMock = DateHandlerMock()
        uuidHandler = UUIDHandlerMock()
        cancellables = .init()
        
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               deckRepository: deckRepository,
                               collectionId: nil,
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
                               collectionId: nil,
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
                               collectionId: nil,
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
                               collectionId: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.pencil.rawValue)
        
        sut.currentSelectedIcon = IconNames.book
        sut.editDeck()
        
        XCTAssertEqual(deckRepository.decks[0].icon, IconNames.book.rawValue)
    }
    
    func testEditDeckError() {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collectionId: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        XCTAssertEqual(deckRepository.decks[0].color, .red)
        
        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        sut.editDeck()
        
        XCTAssertNotEqual(deckRepository.decks[0].color, CollectionColor.darkBlue)
    }
    
    func testDeleteDeckSuccessfully() {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collectionId: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        let id = UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2")
        
        let containsDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsDeck)

        sut.deleteDeck()

        let deletedDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedDeck)
    }
    
    func testDeleteDeckError() {
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               editingDeck: deckRepository.decks[0],
                               deckRepository: deckRepository,
                               collectionId: nil,
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
                )
        
        let id = UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2")
        
        let containsDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsDeck)

        deckRepository.shouldThrowError = true
        sut.deleteDeck()

        let deletedDeck = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(deletedDeck)
    }

}
