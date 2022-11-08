//
//  NewFlashcardFeatureTestsMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 08/11/22.
//

import XCTest
@testable import NewFlashcardFeature
import Storage
import Models
import HummingBird
import Combine
import Utils
import Habitat

#if os(macOS)
class NewFlashcardFeatureTestsMacOS: XCTestCase {
    
    var sut: NewFlashcardViewModelMacOS!
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
        
        sut = NewFlashcardViewModelMacOS()
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
        sut.startUp(NewFlashcardWindowData(deckId: deckRepository.decks[0].id, editingFlashcardId: deckRepository.cards[0].id))
        
        sut.flashcardFront = NSAttributedString(string: "Frente do card")
        sut.flashcardBack = NSAttributedString(string: "Verso do flashard")
        sut.currentSelectedColor = CollectionColor.red
        try sut.createFlashcard()
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsFlashcard)
    }
    
    func testCreateFlashcardError() throws {
        sut.startUp(NewFlashcardWindowData(deckId: deckRepository.decks[0].id, editingFlashcardId: deckRepository.cards[0].id))
        
        sut.flashcardFront = NSAttributedString(string: "frente")
        sut.flashcardBack = NSAttributedString(string: "tras")
        sut.currentSelectedColor = CollectionColor.red
        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createFlashcard())
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertFalse(containsFlashcard)
    }
    
    func testCanSubmitBindingSuccessfully() {
        sut.startUp(NewFlashcardWindowData(deckId: deckRepository.decks[0].id, editingFlashcardId: deckRepository.cards[0].id))
        
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
        sut.editingFlashcard = deckRepository.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.front, NSAttributedString(string: "Parte da frente"))
        
        sut.flashcardFront = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.cards[0].front, NSAttributedString(string: "Novo texto"))
    }
    
    func testEditFlashcardBack() throws {
        sut.editingFlashcard = deckRepository.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.back, NSAttributedString(string: "Parte de tras"))
        
        sut.flashcardBack = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.cards[0].back, NSAttributedString(string: "Novo texto"))
    }
    
    func testEditFlashcardColor() throws {
        sut.editingFlashcard = deckRepository.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.color, CollectionColor.red)
        
        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.cards[0].color, CollectionColor.darkBlue)
    }
    
    func testEditFlashcardError() throws {
        sut.editingFlashcard = deckRepository.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.color, CollectionColor.red)
        
        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        XCTAssertThrowsError(try sut.editFlashcard())
    }
    
    func testDeleteFlashcardSuccessfully() throws {
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
        sut.editingFlashcard = deckRepository.cards[0]
        
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsFlashcard = deckRepository.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsFlashcard)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.deleteFlashcard())
    }
    
    func testFetchInitialDeckSuccessfully() {
        let wantedDeck = deckRepository.decks[0]
        let expectation = expectation(description: "specific deck fetched")
        
        sut.fetchInitialDeck(wantedDeck.id)
        
        sut.$deck.sink { deck in
            XCTAssertEqual(deck, wantedDeck)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchInitialDeckError() {
        let wrongDeckId = UUID(uuidString: "bd08f598-93a7-493b-9acf-5fe3762dfe57")!
        let expectation = expectation(description: "fetch unexisting deck")
        
        sut.fetchInitialDeck(wrongDeckId)
        
        sut.$deck.sink { deck in
            XCTAssertNil(deck)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEditingCardSuccessfully() {
        let wantedCard = deckRepository.cards[0]
        let expectation = expectation(description: "fetch specific card")
        
        sut.$editingFlashcard
            .dropFirst(1)
            .receive(on: RunLoop.main)
            .sink { card in
                XCTAssertEqual(card, wantedCard)
                expectation.fulfill()
        }
        .store(in: &cancellables)
        
        sut.fetchEditingCard(wantedCard.id)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testFetchEditingCardError() {
        let wrongID = UUID(uuidString: "8821596f-b7ff-4604-9b2b-2f12b6fee8fe")
        let expectation = expectation(description: "fetch unexisting card")
        
        sut.$editingFlashcard.sink { card in
            XCTAssertNil(card)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        sut.fetchEditingCard(wrongID)
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchEditingCardNil() {
        let cardId: UUID? = nil
        let expectation = expectation(description: "fetch card with nil id")
        
        sut.$editingFlashcard.sink { card in
            XCTAssertNil(card)
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        sut.fetchEditingCard(cardId)
        wait(for: [expectation], timeout: 1)
    }
    
    func testReset() {
        sut.flashcardFront = NSAttributedString(string: "frente")
        sut.flashcardBack = NSAttributedString(string: "trás")
        sut.currentSelectedColor = .beigeBrown
        sut.reset()
        
        XCTAssertEqual(sut.flashcardFront, NSAttributedString(string: ""))
        XCTAssertEqual(sut.flashcardBack, NSAttributedString(string: ""))
        XCTAssertEqual(sut.currentSelectedColor, .red)
    }
    
    func testSetupDeckContentIntoFields() {
        sut.editingFlashcard = deckRepository.cards[0]
        sut.setupDeckContentIntoFields()
        
        XCTAssertEqual(sut.flashcardBack, sut.editingFlashcard?.back)
        XCTAssertEqual(sut.flashcardFront, sut.editingFlashcard?.front)
        XCTAssertEqual(sut.currentSelectedColor, sut.editingFlashcard?.color)
    }
}
#endif

