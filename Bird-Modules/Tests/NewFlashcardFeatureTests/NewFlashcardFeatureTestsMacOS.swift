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
    var deck: Deck!
    var cards: [Card]!
    
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        dateHandlerMock = DateHandlerMock()
        uuidHandler = UUIDHandlerMock()
        cancellables = .init()
        
        setupHabitatForIsolatedTesting(deckRepository: deckRepository, dateHandler: dateHandlerMock, uuidGenerator: uuidHandler)
        
        sut = NewFlashcardViewModelMacOS()
        createData()
    }
    
    func createData() {
        createCards()
        createDecks()
        
        try? deckRepository.createDeck(deck, cards: cards)
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
        dateHandlerMock = nil
        uuidHandler = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
        deck = nil
        cards = nil
    }
    
    func testCreateFlashcardSuccessfully() throws {
        sut.startUp(NewFlashcardWindowData(deckId: deckRepository.data[deck.id]!.deck.id, editingFlashcardId: deckRepository.data[deck.id]!.cards[0].id))
        
        sut.flashcardFront = NSAttributedString(string: "Frente do card")
        sut.flashcardBack = NSAttributedString(string: "Verso do flashard")
        sut.currentSelectedColor = CollectionColor.red
        try sut.createFlashcard()
        
        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsFlashcard)
    }
    
    func testCreateFlashcardError() throws {
        sut.startUp(NewFlashcardWindowData(deckId: deckRepository.data[deck.id]!.deck.id, editingFlashcardId: deckRepository.data[deck.id]!.cards[0].id))
        
        sut.flashcardFront = NSAttributedString(string: "frente")
        sut.flashcardBack = NSAttributedString(string: "tras")
        sut.currentSelectedColor = CollectionColor.red
        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createFlashcard())
        
        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertFalse(containsFlashcard)
    }
    
    func testCanSubmitBindingSuccessfully() {
        sut.startUp(NewFlashcardWindowData(deckId: deckRepository.data[deck.id]!.deck.id, editingFlashcardId: deckRepository.data[deck.id]!.cards[0].id))
        
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
        sut.editingFlashcard = deckRepository.data[deck.id]!.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.front, NSAttributedString(string: "Parte da frente"))
        
        sut.flashcardFront = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.data[deck.id]!.cards[0].front, NSAttributedString(string: "Novo texto"))
    }
    
    func testEditFlashcardBack() throws {
        sut.editingFlashcard = deckRepository.data[deck.id]!.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.back, NSAttributedString(string: "Parte de tras"))
        
        sut.flashcardBack = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.data[deck.id]!.cards[0].back, NSAttributedString(string: "Novo texto"))
    }
    
    func testEditFlashcardColor() throws {
        sut.editingFlashcard = deckRepository.data[deck.id]!.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.color, CollectionColor.red)
        
        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editFlashcard()

        XCTAssertEqual(deckRepository.data[deck.id]!.cards[0].color, CollectionColor.darkBlue)
    }
    
    func testEditFlashcardError() throws {
        sut.editingFlashcard = deckRepository.data[deck.id]!.cards[0]
        
        XCTAssertEqual(sut.editingFlashcard?.color, CollectionColor.red)
        
        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        XCTAssertThrowsError(try sut.editFlashcard())
    }
    
    func testDeleteFlashcardSuccessfully() throws {
        sut.editingFlashcard = deckRepository.data[deck.id]!.cards.first
        
        let id = deckRepository.data[deck.id]!.cards.first?.id
        
        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsFlashcard)

        try sut.deleteFlashcard()

        let deletedCard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertFalse(deletedCard)
    }
    
    func testDeleteFlashcardError() throws {
        sut.editingFlashcard = cards[0]
        
        let id = deckRepository.data[deck.id]!.cards.first?.id
        
        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsFlashcard)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.editFlashcard())
    }
    
    func testFetchInitialDeckSuccessfully() {
        let wantedDeck = deck
        let expectation = expectation(description: "specific deck fetched")
        
        sut.fetchInitialDeck(wantedDeck!.id)
        
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
        let wantedCard = cards[0]
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
        sut.editingFlashcard = cards[0]
        sut.setupDeckContentIntoFields()
        
        XCTAssertEqual(sut.flashcardBack, sut.editingFlashcard?.back)
        XCTAssertEqual(sut.flashcardFront, sut.editingFlashcard?.front)
        XCTAssertEqual(sut.currentSelectedColor, sut.editingFlashcard?.color)
    }
    
    func createCards() {
        cards = []
        var i = 0
        while i < 7 {
            cards.append(createNewCard(state: .learn))
            i += 1
        }
        
        i = 0
        while i < 5 {
            cards.append(createNewCard(state: .review))
            i += 1
        }
    }
    
    func createNewCard(state: WoodpeckerState) -> Card {
        Card(id: UUID(),
             front: NSAttributedString(string: "Parte da frente"),
             back: NSAttributedString(string: "Parte de tras"),
             color: CollectionColor.red,
             datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                 lastEdit: Date(timeIntervalSince1970: 0),
                                 createdAt: Date(timeIntervalSince1970: 0)),
             deckID: UUID(),
             woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                    isGraduated: state == .review ? true : false,
                                                    easeFactor: 2.5, streak: 0,
                                                    interval: state == .review ? 1 : 0,
                                                    hasBeenPresented: state == .review ? true : false),
             history: state == .review ? [CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                              isGraduated: false,
                                                                                              easeFactor: 2.5,
                                                                                              streak: 0,
                                                                                              interval: 0,
                                                                                              hasBeenPresented: false),
                                                       userGrade: .correct,
                                                       timeSpend: 20,
                                                       date: Date(timeIntervalSince1970: -86400))] : [])
        
    }
    
    func createDecks() {
        deck = newDeck()
        
    }
    
    func newDeck() -> Deck {
        Deck(id: UUID(),
             name: "Programação Swift",
             icon: IconNames.atom.rawValue,
             color: CollectionColor.red,
             datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                 lastEdit: Date(timeIntervalSince1970: 0),
                                 createdAt: Date(timeIntervalSince1970: 0)),
             collectionId: nil,
             cardsIds: [],
             spacedRepetitionConfig: .init(maxLearningCards: 20, maxReviewingCards: 200, numberOfSteps: 4),
             category: DeckCategory.arts,
             storeId: nil, description: "", ownerId: nil)
    }
    enum WoodpeckerState {
        case review, learn
    }
}
#endif

