//
//  DeckViewModelTests.swift
//
//
//  Created by Caroline Taus on 14/09/22.
//

import XCTest
@testable import DeckFeature
import Storage
import Models
import HummingBird
import Combine
import Utils
import Habitat

@MainActor
final class DeckViewModelTests: XCTestCase {

    var sut: DeckViewModel!
    var deckRepositoryMock: DeckRepositoryMock!
    var dateHandler: DateHandlerMock!
    var uuidGenerator: UUIDGeneratorProtocol!
    var cancellables: Set<AnyCancellable>!
    
    var deck0: Deck!
    var deck1: Deck!
    var deck2: Deck!
    var deck3: Deck!
    var cards: [Card]!

    override func setUp() {
        deckRepositoryMock = DeckRepositoryMock()
        dateHandler = DateHandlerMock()
        uuidGenerator = UUIDHandlerMock()
        setupHabitatForIsolatedTesting(deckRepository: deckRepositoryMock, dateHandler: dateHandler, uuidGenerator: uuidGenerator)
        sut = DeckViewModel()
        cancellables = .init()
        createData()
        sut.startup(deckRepositoryMock.data[deck0.id]!.deck)
    }
    
    func createData() {
        createCards()
        createDecks()
        
        try? deckRepositoryMock.createDeck(deck0, cards: cards)
        try? deckRepositoryMock.createDeck(deck1, cards: [])
        try? deckRepositoryMock.createDeck(deck2, cards: [])
        try? deckRepositoryMock.createDeck(deck3, cards: [])
    }

    override func tearDown() {
        sut = nil
        deckRepositoryMock = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
        deck0 = nil
        deck1 = nil
        deck2 = nil
        deck3 = nil
        
        cards = nil
    }

    func testStartup() throws {
        let cardExpectation = expectation(description: "card reacting to Repository Action")

        try deckRepositoryMock.addCard(Card(id: UUID(), front: NSAttributedString(), back: NSAttributedString(), color: .red, datesLogs: DateLogs(), deckID: deck0.id, woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false), history: []), to: deckRepositoryMock.data[deck0.id]!.deck)

        sut.$cards
            .sink {[unowned self] cards in
                XCTAssertEqual(cards, self.deckRepositoryMock.data[deck0.id]!.cards.sorted {c1, c2 in c1.datesLogs.createdAt > c2.datesLogs.createdAt})
                cardExpectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [cardExpectation], timeout: 1)
    }

    func testDeleteFlashcard() throws {

        let containsCard = deckRepositoryMock.data[deck0.id]!.cards.contains(where: {
            $0.id == self.cards[0].id
        })

        XCTAssertTrue(containsCard)

        try sut.deleteFlashcard(card: deckRepositoryMock.data[deck0.id]!.cards.first(where: { cards[0].id == $0.id })!)

        let deletedDeck = deckRepositoryMock.data[deck0.id]!.cards.contains(where: {
            $0.id == self.cards[0].id
        })

        XCTAssertFalse(deletedDeck)
    }

    func testSearchCardFront() {
        sut.searchFieldContent = "front"

        let count = sut.cardsSearched.count

        XCTAssertEqual(count, deckRepositoryMock.data[deck0.id]!.cards.count)
    }

    func testSearchCardBack() {
        sut.searchFieldContent = "back"

        let count = sut.cardsSearched.count

        XCTAssertEqual(count, deckRepositoryMock.data[deck0.id]!.cards.count)
    }

    func testSearchNoResults() {
        sut.searchFieldContent = "teste"

        let count = sut.cardsSearched.count

        XCTAssertEqual(count, 0)
    }

    func testCanStudyTrue() {
        XCTAssertTrue(sut.checkIfCanStudy(deckRepositoryMock.data[deck0.id]!.deck))
    }

    func testCanStudyFalse() {
        sut = DeckViewModel()
        sut.startup(deckRepositoryMock.data[deck2.id]!.deck)

        XCTAssertFalse(sut.checkIfCanStudy(deckRepositoryMock.data[deck2.id]!.deck))
    }

    func testCheckIfcanStudyWithSession() throws {
        let session = Session(cardIds: deckRepositoryMock.data[deck0.id]!.deck.cardsIds, date: dateHandler.today, deckId: deck0.id, id: uuidGenerator.newId())
        try deckRepositoryMock.createSession(session, for: deckRepositoryMock.data[deck0.id]!.deck)
        sut.startup(deckRepositoryMock.data[deck0.id]!.deck)
        XCTAssertTrue(sut.checkIfCanStudy(deckRepositoryMock.data[deck0.id]!.deck))
    }

    func testCheckIfcanStudyWithEmptySession() throws {
        let session = Session(cardIds: deckRepositoryMock.data[deck2.id]!.deck.cardsIds, date: dateHandler.today, deckId: deck2.id, id: uuidGenerator.newId())
        try deckRepositoryMock.createSession(session, for: deckRepositoryMock.data[deck2.id]!.deck)
        sut.startup(deckRepositoryMock.data[deck2.id]!.deck)
        XCTAssertFalse(sut.checkIfCanStudy(deckRepositoryMock.data[deck2.id]!.deck))
    }

    func testCheckIfLastAccessIsChanged() {
        dateHandler.customToday = Date(timeIntervalSince1970: 1000)
        sut.startup(deckRepositoryMock.data[deck0.id]!.deck)

        XCTAssertEqual(dateHandler.customToday, deckRepositoryMock.data[deck0.id]!.deck.datesLogs.lastAccess)
    }
    
    enum WoodpeckerState {
        case review, learn
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
        deck0 = newDeck()
        deck1 = newDeck()
        deck2 = newDeck()
        deck3 = newDeck()
    }
    
    func newDeck() -> Deck {
        Deck(id: UUID(),
             name: "Deck0",
             icon: IconNames.abc.rawValue,
             color: CollectionColor.red,
             datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                 lastEdit: Date(timeIntervalSince1970: 0),
                                 createdAt: Date(timeIntervalSince1970: 0)),
             collectionId: nil,
             cardsIds: [],
             spacedRepetitionConfig: .init(maxLearningCards: 20, maxReviewingCards: 200, numberOfSteps: 4),
             category: DeckCategory.arts,
             storeId: nil)
    }
    
    func sortById<T: Identifiable>(d0: T, d1: T) -> Bool where T.ID == UUID {
        return d0.id.uuidString > d1.id.uuidString
    }

}
