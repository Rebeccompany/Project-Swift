//
//  SessionsForTodayTests.swift
//  
//
//  Created by Caroline Taus on 01/11/22.
//

import Foundation
import XCTest
@testable import AppFeature
import Models
import Storage
import Habitat
import Combine
import Utils

final class SessionsForTodayTests: XCTestCase {
    var sut: ContentViewModel!
    var deckRepositoryMock: DeckRepositoryMock!
    var displayCacherMock: DisplayCacher!
    var localStorageMock: LocalStorageMock!
    var uuidGeneratorMock: UUIDHandlerMock!
    var dateHandler: DateHandlerMock!
    var collectionRepositoryMock: CollectionRepositoryMock!
    var cancelables: Set<AnyCancellable>!
    
    var pastDDCards: [Card] = []
    var todayDDCards: [Card] = []
    var futureDDCards: [Card] = []
    var nilDDCards: [Card] = []
    let deck = Deck(id: UUID(),
                    name: "Deck Exemplo",
                    icon: "flame",
                    color: CollectionColor.red,
                    collectionId: nil,
                    cardsIds: [],
                    category: .arts,
                    storeId: nil,
                    description: "",
                    ownerId: nil)
    
    override func setUp() {
        deckRepositoryMock = DeckRepositoryMock()
        collectionRepositoryMock = CollectionRepositoryMock()
        localStorageMock = LocalStorageMock()
        uuidGeneratorMock = UUIDHandlerMock()
        dateHandler = DateHandlerMock()
        displayCacherMock = DisplayCacher(localStorage: localStorageMock)
        setupHabitatForIsolatedTesting(deckRepository: deckRepositoryMock,
                                       collectionRepository: collectionRepositoryMock,
                                       displayCacher: displayCacherMock)
        sut = ContentViewModel()
        cancelables = Set<AnyCancellable>()

        createCards()
    }
    
    override func tearDown() {
        cancelables.forEach { cancellable in
            cancellable.cancel()
        }
        
        sut = nil
        collectionRepositoryMock = nil
        deckRepositoryMock = nil
        dateHandler = nil
        uuidGeneratorMock = nil
        cancelables = nil
    }
    
    
    // Tests with cards that have dueDates only in the past
    func testSessionNeverStartedDDPast() throws {
        try deckRepositoryMock.createDeck(deck, cards: pastDDCards)
        sut.startup()
        
        XCTAssertTrue(sut.decks.contains(where: {$0.id == deck.id}))
        XCTAssertTrue(sut.todayDecks.isEmpty)
    }
    
    func testSessionHasStartedBeforeDDPast() throws {
        try deckRepositoryMock.createDeck(deck, cards: pastDDCards)
        
        try deckRepositoryMock.createSession(Session(cardIds: pastDDCards.map(\.id), date: dateHandler.today.addingTimeInterval(-86400), deckId: deck.id, id: UUID()), for: deck)
        sut.startup()
        
        XCTAssertTrue(sut.decks.contains(where: {$0.id == deck.id}))
        XCTAssertTrue(sut.todayDecks.contains(where: {$0.id == deck.id}))
    }
    
    
    // Tests with cards that have dueDates only for today
    func testSessionNeverStartedDDToday() throws {
        try deckRepositoryMock.createDeck(deck, cards: todayDDCards)
        sut.startup()
        
        XCTAssertTrue(sut.decks.contains(where: {$0.id == deck.id}))
        XCTAssertTrue(sut.todayDecks.isEmpty)
    }
    
    func testSessionHasStartedBeforeDDToday() throws {
        try deckRepositoryMock.createDeck(deck, cards: todayDDCards)
        
        try deckRepositoryMock.createSession(Session(cardIds: todayDDCards.map(\.id), date: dateHandler.today, deckId: deck.id, id: UUID()), for: deck)
        sut.startup()
        
        XCTAssertTrue(sut.decks.contains(where: {$0.id == deck.id}))
        XCTAssertTrue(sut.todayDecks.contains(where: {$0.id == deck.id}))
    }
    
    
    // Tests with cards that have dueDates only for the future
    func testSessionDDFuture() throws {
        try deckRepositoryMock.createDeck(deck, cards: futureDDCards)
        sut.startup()
        XCTAssertTrue(sut.decks.contains(where: {$0.id == deck.id}))
        XCTAssertTrue(sut.todayDecks.isEmpty)
    }

    // Tests with cards that have dueDates = nil
    func testSessionDDNil() throws {
        try deckRepositoryMock.createDeck(deck, cards: nilDDCards)
        sut.startup()
        
        XCTAssertTrue(sut.decks.contains(where: {$0.id == deck.id}))
        XCTAssertTrue(sut.todayDecks.isEmpty)
    }
    
    func createCards() {
        pastDDCards = [
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "frente past"),
                 back: NSAttributedString(string: "trás past"),
                 color: CollectionColor.beigeBrown,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(interval: 1, hasBeenPresented: true),
                 history: [
                    CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                                 userGrade: .correctEasy,
                                 timeSpend: 22,
                                 date: dateHandler.today.addingTimeInterval(-172800))
                 ]),
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "front past"),
                 back: NSAttributedString(string: "back past"),
                 color: CollectionColor.beigeBrown,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(interval: 1, hasBeenPresented: true),
                 history: [
                    CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                                 userGrade: .correctEasy,
                                 timeSpend: 29,
                                 date: dateHandler.today.addingTimeInterval(-172800))
                 ])
        ]
        
        todayDDCards = [
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "frente past"),
                 back: NSAttributedString(string: "trás past"),
                 color: CollectionColor.gray,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(interval: 1, hasBeenPresented: true),
                 history: [
                    CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                                 userGrade: .correctEasy,
                                 timeSpend: 20,
                                 date: dateHandler.today.addingTimeInterval(-86400))
                 ]),
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "front today"),
                 back: NSAttributedString(string: "back today"),
                 color: CollectionColor.green,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(interval: 1, hasBeenPresented: true),
                 history: [
                    CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                                 userGrade: .correctEasy,
                                 timeSpend: 27,
                                 date: dateHandler.today.addingTimeInterval(-86400))
                 ])
        ]
        
        futureDDCards = [
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "frente future"),
                 back: NSAttributedString(string: "trás future"),
                 color: CollectionColor.red,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(interval: 1, hasBeenPresented: true),
                 history: [
                    CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                                 userGrade: .correctEasy,
                                 timeSpend: 27,
                                 date: dateHandler.today)
                 ]),
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "front future"),
                 back: NSAttributedString(string: "back future"),
                 color: CollectionColor.red,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(interval: 1, hasBeenPresented: true),
                 history: [
                    CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                                 userGrade: .correctEasy,
                                 timeSpend: 37,
                                 date: dateHandler.today)
                 ])
        ]
        
        nilDDCards = [
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "frente nil"),
                 back: NSAttributedString(string: "trás nil"),
                 color: CollectionColor.darkPurple,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                 history: []),
            Card(id: uuidGeneratorMock.newId(),
                 front: NSAttributedString(string: "front nil"),
                 back: NSAttributedString(string: "back nil"),
                 color: CollectionColor.darkBlue,
                 datesLogs: DateLogs(),
                 deckID: UUID(),
                 woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                 history: [])
        ]
        
        
    }
    
}
