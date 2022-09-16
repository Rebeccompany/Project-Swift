//
//  File.swift
//  
//
//  Created by Rebecca Mello on 15/09/22.
//

import XCTest
@testable import NewFlashcardFeature
import Storage
import Models
import HummingBird
import Combine
import Utils

class NewFlashcardFeatureTests: XCTestCase {
    
    var sut: NewFlashcardViewModel!
    var deckRepository: DeckRepositoryMock!
    var dateHandlerMock: DateHandlerMock!
    var uuidHandler: UUIDHandlerMock!
    var cancellables: Set<AnyCancellable>!
    
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        dateHandlerMock = DateHandlerMock()
        uuidHandler = UUIDHandlerMock()
        cancellables = .init()
        
        sut = NewFlashcardViewModel(
            colors: CollectionColor.allCases,
            deckRepository: deckRepository,
            deck: deckRepository.decks[0],
            dateHandler: dateHandlerMock,
            uuidGenerator: uuidHandler)
        
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
    
    func testCreateFlashcardSuccessfully() {
        sut.flashcardFront = "Frente do card"
        sut.flashcardBack = "Verso do flashard"
        sut.currentSelectedColor = CollectionColor.red
        sut.createFlashcard()
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsFlashcard)
    }
    
    func testCreateFlashcardError() {
        sut.flashcardFront = "frente"
        sut.flashcardBack = "tras"
        sut.currentSelectedColor = CollectionColor.red
        deckRepository.shouldThrowError = true
        sut.createFlashcard()
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertFalse(containsFlashcard)
    }
    
    func testCanSubmitBindingSuccessfully() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardFront = "frente"
        sut.flashcardBack = "tras"
        sut.currentSelectedColor = CollectionColor.red
        sut.$canSubmit.sink { canSubmit in
            XCTAssertTrue(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoFront() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardBack = "tras"
        sut.currentSelectedColor = CollectionColor.red
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoBack() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardFront = "frente"
        sut.currentSelectedColor = CollectionColor.red
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColor() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardFront = "frente"
        sut.flashcardBack = "tras"
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColorAndFront() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardBack = "tras"
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColorAndBack() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardFront = "frente"
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoFrontAndBack() {
        let expectations = expectation(description: "Can submit binding")
        sut.currentSelectedColor = CollectionColor.red
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoFrontAndBackAndColor() {
        let expectations = expectation(description: "Can submit binding")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testEditFlashcardFront() throws {
        sut = NewFlashcardViewModel(colors: CollectionColor.allCases, editingFlashcard: deckRepository.cards[0], deckRepository: deckRepository, deck: deckRepository.decks[0])
                
        XCTAssertEqual(deckRepository.cards[0].front, "Parte da frente")
        
        sut.flashcardFront = "Novo texto"
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.cards[0].front, "Novo texto")
    }
    
    func testEditFlashcardBack() throws {
        sut = NewFlashcardViewModel(colors: CollectionColor.allCases, editingFlashcard: deckRepository.cards[0], deckRepository: deckRepository, deck: deckRepository.decks[0])
                
        XCTAssertEqual(deckRepository.cards[0].back, "Parte de tras")
        
        sut.flashcardBack = "Novo texto"
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.cards[0].back, "Novo texto")
    }
    
    func testEditFlashcardColor() throws {
        sut = NewFlashcardViewModel(colors: CollectionColor.allCases, editingFlashcard: deckRepository.cards[0], deckRepository: deckRepository, deck: deckRepository.decks[0])
                
        XCTAssertEqual(deckRepository.cards[0].color, CollectionColor.red)
        
        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.cards[0].color, CollectionColor.darkBlue)
    }
    
    func testEditFlashcardError() throws {
        sut = NewFlashcardViewModel(colors: CollectionColor.allCases, editingFlashcard: deckRepository.cards[0], deckRepository: deckRepository, deck: deckRepository.decks[0])
                
        XCTAssertEqual(deckRepository.cards[0].color, CollectionColor.red)
        
        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        XCTAssertThrowsError(try sut.editFlashcard())
    }
    
    func testDeleteFlashcardSuccessfully() throws {
        sut = NewFlashcardViewModel(colors: CollectionColor.allCases, editingFlashcard: deckRepository.cards[0], deckRepository: deckRepository, deck: deckRepository.decks[0])
        
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsFlashcard)

        try sut.deleteFlashcard()

        let deletedCard = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedCard)
    }
    
    func testDeleteFlashcardError() throws {
        sut = NewFlashcardViewModel(colors: CollectionColor.allCases, editingFlashcard: deckRepository.cards[0], deckRepository: deckRepository, deck: deckRepository.decks[0])
        
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsFlashcard)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.editFlashcard())
    }
}
