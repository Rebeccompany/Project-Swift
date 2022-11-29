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
    var deck: Deck!
    var cards: [Card]!


    override func setUp() {
        deckRepository = DeckRepositoryMock()
        dateHandlerMock = DateHandlerMock()
        collectionRepository = CollectionRepositoryMock()
        uuidHandler = UUIDHandlerMock()
        cancellables = .init()

        setupHabitatForIsolatedTesting(deckRepository: deckRepository, collectionRepository: collectionRepository, dateHandler: dateHandlerMock, uuidGenerator: uuidHandler)
        sut = NewDeckViewModel()
        sut.startUp(editingDeck: nil)
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
        collectionRepository = nil
        dateHandlerMock = nil
        uuidHandler = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
        deck = nil
        cards = nil
    }

    func testCreateDeckSuccessfully() throws {
        try sut.createDeck(collection: nil)

        let containsNewDeck = deckRepository.data.values.map(\.deck).contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })

        XCTAssertTrue(containsNewDeck)
    }

    func testCreateDeckWithCollectionSucessfully() throws {
        try sut.createDeck(collection: collectionRepository.collections[0])

        let collectionsContainsNewDeck = collectionRepository.collections[0].decksIds.contains(uuidHandler.lastCreatedID!)

        let newDeck = deckRepository.data.values.map(\.deck).first(where: {
            $0.id == uuidHandler.lastCreatedID
        })

        XCTAssertNotNil(newDeck)
        XCTAssertTrue(collectionsContainsNewDeck)
        XCTAssertEqual(newDeck?.collectionId, collectionRepository.collections[0].id)
    }

    func testCreateDeckError() throws {
        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.createDeck(collection: nil))

        let containsNewDeck = deckRepository.data.values.map(\.deck).contains(where: {
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
        XCTAssertEqual(deckRepository.data[deck.id]!.deck.name, "Programação Swift")

        sut.deckName = "New name"
        try sut.editDeck(editingDeck: deckRepository.data[deck.id]!.deck)

        XCTAssertEqual(deckRepository.data[deck.id]!.deck.name, "New name")
    }

    func testEditDeckColor() throws {
        XCTAssertEqual(deckRepository.data[deck.id]!.deck.color, .red)

        sut.currentSelectedColor = CollectionColor.darkBlue
        try sut.editDeck(editingDeck: deckRepository.data[deck.id]!.deck)

        XCTAssertEqual(deckRepository.data[deck.id]!.deck.color, .darkBlue)
    }

    func testEditDeckIcon() throws {
        XCTAssertEqual(deckRepository.data[deck.id]!.deck.icon, IconNames.atom.rawValue)

        sut.currentSelectedIcon = IconNames.books
        try sut.editDeck(editingDeck: deckRepository.data[deck.id]!.deck)

        XCTAssertEqual(deckRepository.data[deck.id]!.deck.icon, IconNames.books.rawValue)
    }

    func testEditDeckError() throws {
        XCTAssertEqual(deckRepository.data[deck.id]!.deck.color, .red)

        deckRepository.shouldThrowError = true
        sut.currentSelectedColor = CollectionColor.darkBlue
        XCTAssertThrowsError(try sut.editDeck(editingDeck: deckRepository.data[deck.id]!.deck))

        XCTAssertNotEqual(deckRepository.data[deck.id]!.deck.color, CollectionColor.darkBlue)
    }

    func testDeleteDeckSuccessfully() throws {
        let id = deck.id

        let containsDeck = deckRepository.data.values.map(\.deck).contains(where: {
            $0.id == id
        })

        XCTAssertTrue(containsDeck)

        try sut.deleteDeck(editingDeck: deckRepository.data[deck.id]!.deck)

        let deletedDeck = deckRepository.data.values.map(\.deck).contains(where: {
            $0.id == id
        })

        XCTAssertFalse(deletedDeck)
    }

    func testDeleteDeckError() throws {
        let id = deck.id

        let containsDeck = deckRepository.data.values.map(\.deck).contains(where: {
            $0.id == id
        })

        XCTAssertTrue(containsDeck)

        deckRepository.shouldThrowError = true
        XCTAssertThrowsError(try sut.deleteDeck(editingDeck: deckRepository.data[deck.id]!.deck))

        let deletedDeck = deckRepository.data.values.map(\.deck).contains(where: {
            $0.id == id
        })

        XCTAssertTrue(deletedDeck)
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
             front: NSAttributedString(string: "front"),
             back: NSAttributedString(string: "back"),
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
             storeId: nil, description: "" )
    }
    
    enum WoodpeckerState {
        case review, learn
    }

}
