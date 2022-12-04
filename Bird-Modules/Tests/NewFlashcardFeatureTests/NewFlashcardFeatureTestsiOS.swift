//
//  NewFlashcardFeatureTests.swift
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

#if os(iOS)
class NewFlashcardFeatureTestsiOS: XCTestCase {
    
    var sut: NewFlashcardViewModeliOS!
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
        
        sut = NewFlashcardViewModeliOS()
    
        sut.startUp(editingFlashcard: nil)
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
        sut.flashcardFront = NSAttributedString(string: "Frente do card")
        sut.flashcardBack = NSAttributedString(string: "Verso do flashard")
        sut.currentSelectedColor = CollectionColor.red
        try sut.createFlashcard(for: deckRepository.data[deck.id]!.deck)

        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })

        XCTAssertTrue(containsFlashcard)
    }

    func testCreateFlashcardError() throws {
        sut.flashcardFront = NSAttributedString(string: "frente")
        sut.flashcardBack = NSAttributedString(string: "tras")
        sut.currentSelectedColor = CollectionColor.red
        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createFlashcard(for: deckRepository.data[deck.id]!.deck))

        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
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
        var card = deckRepository.data[deck.id]!.cards.first
        XCTAssertEqual(card!.front, NSAttributedString(string: "Parte da frente"))

        sut.flashcardFront = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard(editingFlashcard: card)
        card = deckRepository.data[deck.id]!.cards.first

        XCTAssertEqual(card!.front, NSAttributedString(string: "Novo texto"))
    }

    func testEditFlashcardBack() throws {
        var card = deckRepository.data[deck.id]!.cards.first
        XCTAssertEqual(card!.back, NSAttributedString(string: "Parte de tras"))

        sut.flashcardBack = NSAttributedString(string: "Novo texto")
        try sut.editFlashcard(editingFlashcard: card)
        card = deckRepository.data[deck.id]!.cards.first

        XCTAssertEqual(card!.back, NSAttributedString(string: "Novo texto"))
    }

    func testEditFlashcardColor() throws {
        var card = deckRepository.data[deck.id]!.cards.first
        XCTAssertEqual(card!.color, CollectionColor.red)

        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editFlashcard(editingFlashcard: card)
        card = deckRepository.data[deck.id]!.cards.first

        XCTAssertEqual(card!.color, CollectionColor.darkBlue)
    }

    func testEditFlashcardError() throws {
        var card = deckRepository.data[deck.id]!.cards.first
        XCTAssertEqual(card!.color, CollectionColor.red)

        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        card = deckRepository.data[deck.id]!.cards.first
        XCTAssertThrowsError(try sut.editFlashcard(editingFlashcard: card))
    }

    func testDeleteFlashcardSuccessfully() throws {
        let id = deckRepository.data[deck.id]!.cards.first?.id
        

        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == id
        })

        XCTAssertTrue(containsFlashcard)

        try sut.deleteFlashcard(editingFlashcard: deckRepository.data[deck.id]!.cards.first)

        let deletedCard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == id
        })

        XCTAssertFalse(deletedCard)
    }

    func testDeleteFlashcardError() throws {
        let id = deckRepository.data[deck.id]!.cards.first?.id

        let containsFlashcard = deckRepository.data[deck.id]!.cards.contains(where: {
            $0.id == id
        })

        XCTAssertTrue(containsFlashcard)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.editFlashcard(editingFlashcard: deckRepository.data[deck.id]!.cards.first))
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
