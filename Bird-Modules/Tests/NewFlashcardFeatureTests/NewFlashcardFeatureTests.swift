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
import Habitat

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
        
        setupHabitatForIsolatedTesting(deckRepository: deckRepository, dateHandler: dateHandlerMock, uuidGenerator: uuidHandler)
        
        sut = NewFlashcardViewModel()
    
        sut.startUp(editingFlashcard: nil)
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
        dateHandlerMock = nil
        uuidHandler = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
    }
    
    func testCreateFlashcardSuccessfully() throws {
        sut.flashcardFront = NSAttributedString(string: "Frente do card")
        sut.flashcardBack = NSAttributedString(string: "Verso do flashard")
        sut.currentSelectedColor = CollectionColor.red
        try sut.createFlashcard(for: deckRepository.decks[0])
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsFlashcard)
    }
    
    func testCreateFlashcardError() throws {
        sut.flashcardFront = NSAttributedString(string: "frente")
        sut.flashcardBack = NSAttributedString(string: "tras")
        sut.currentSelectedColor = CollectionColor.red
        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createFlashcard(for: deckRepository.decks[0]))
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertFalse(containsFlashcard)
    }
    
    func testCanSubmitBindingSuccessfully() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardFront = NSAttributedString(string: "frente")
        sut.flashcardBack = NSAttributedString(string: "tras")
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
        sut.flashcardBack = NSAttributedString(string: "tras")
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
        sut.flashcardFront = NSAttributedString(string: "frente")
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
        sut.flashcardFront = NSAttributedString(string: "frente")
        sut.flashcardBack = NSAttributedString(string: "tras")
        sut.currentSelectedColor = nil
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColorAndFront() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardBack = NSAttributedString(string: "tras")
        sut.$canSubmit.sink { canSubmit in
            XCTAssertFalse(canSubmit)
            expectations.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectations], timeout: 1)
    }
    
    func testCanSubmitBindingErrorNoColorAndBack() {
        let expectations = expectation(description: "Can submit binding")
        sut.flashcardFront = NSAttributedString(string: "frente")
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
        XCTAssertEqual(deckRepository.cards[0].front, NSAttributedString(string: "Parte da frente"))
        
        sut.flashcardFront = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard(editingFlashcard: deckRepository.cards[0])

        XCTAssertEqual(deckRepository.cards[0].front, NSAttributedString(string: "Novo texto"))
    }
    
    func testEditFlashcardBack() throws {
        XCTAssertEqual(deckRepository.cards[0].back, NSAttributedString(string: "Parte de tras"))
        
        sut.flashcardBack = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard(editingFlashcard: deckRepository.cards[0])

        XCTAssertEqual(deckRepository.cards[0].back, NSAttributedString(string: "Novo texto"))
    }
    
    func testEditFlashcardColor() throws {
        XCTAssertEqual(deckRepository.cards[0].color, CollectionColor.red)
        
        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editFlashcard(editingFlashcard: deckRepository.cards[0])

        XCTAssertEqual(deckRepository.cards[0].color, CollectionColor.darkBlue)
    }
    
    func testEditFlashcardError() throws {
        XCTAssertEqual(deckRepository.cards[0].color, CollectionColor.red)
        
        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        XCTAssertThrowsError(try sut.editFlashcard(editingFlashcard: deckRepository.cards[0]))
    }
    
    func testDeleteFlashcardSuccessfully() throws {
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsFlashcard)

        try sut.deleteFlashcard(editingFlashcard: deckRepository.cards[0])

        let deletedCard = deckRepository.decks.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedCard)
    }
    
    func testDeleteFlashcardError() throws {
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsFlashcard)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.editFlashcard(editingFlashcard: deckRepository.cards[0]))
    }
    
    func testFetchInitialDeckSuccessfully() {
        let wantedDeck = deckRepository.decks[0]
        let expectation = expectation(description: "specific deck fetched")
        
        sut.fetchInitialDeck(wantedDeck.id).sink { deck in
            XCTAssertEqual(deck, wantedDeck)
            expectation.fulfill()
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchInitialDeckError() {
        let wrongDeckId = UUID(uuidString: "bd08f598-93a7-493b-9acf-5fe3762dfe57")!
        let expectation = expectation(description: "fetch unexisting deck")
        
        sut.fetchInitialDeck(wrongDeckId).sink { deck in
            XCTAssertNil(deck)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEditingCardSuccessfully() {
        let wantedCard = deckRepository.cards[0]
        let expectation = expectation(description: "fetch specific card")
        
        sut.fetchEditingCard(wantedCard.id).sink { card in
            XCTAssertEqual(card, wantedCard)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEditingCardError() {
        let wrongID = UUID(uuidString: "8821596f-b7ff-4604-9b2b-2f12b6fee8fe")
        let expectation = expectation(description: "fetch unexisting card")
        
        sut.fetchEditingCard(wrongID).sink { card in
            XCTAssertNil(card)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEditingCardNil() {
        let cardId: UUID? = nil
        let expectation = expectation(description: "fetch card with nil id")
        
        sut.fetchEditingCard(cardId).sink { card in
            XCTAssertNil(card)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
