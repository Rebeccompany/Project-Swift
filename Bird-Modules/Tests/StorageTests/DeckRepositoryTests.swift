//
//  DeckRepositoryTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/08/22.
//

import XCTest
@testable import Storage
import Combine
import Models

final class DeckRepositoryTests: XCTestCase {
    
    var sut: DeckRepository! = nil
    var deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>! = nil
    var cardRepository: Repository<Card, CardEntity, CardModelEntityTransformer>! = nil
    var sessionRepository: Repository<Session, SessionEntity, SessionModelEntityTransformer>! = nil
    var sessionTransformer: SessionModelEntityTransformer! = nil
    var dataStorage: DataStorage! = nil
    
    var cancellables: Set<AnyCancellable>! = nil
    
    override func setUp() {
        self.sessionTransformer = .init()
        self.dataStorage = DataStorage(.inMemory)
        self.deckRepository = Repository(transformer: DeckModelEntityTransformer(), dataStorage)
        self.cardRepository = Repository(transformer: CardModelEntityTransformer(), dataStorage)
        self.sessionRepository = Repository(transformer: sessionTransformer, dataStorage)
        self.sut = DeckRepository(deckRepository: deckRepository, cardRepository: cardRepository, sessionRepository: sessionRepository)
        self.cancellables = .init()
    }
    
    override func tearDown() {
        self.cancellables.forEach { c in c.cancel() }
        self.cancellables = nil
        
        self.sut = nil
        self.cardRepository = nil
        self.deckRepository = nil
        self.dataStorage = nil
    }
    
    func testFetchDeckById() throws {
        _ = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        try createStandardDeck()
        
        let expectation = expectation(description: "fetch a single Deck")
        
        let expectedDeck = DeckDummy.dummy
        //expectedDeck.cardsIds.append(CardDummy.dummy.id)
        
        sut.fetchDeckById(DeckDummy.dummy.id)
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { deck in
                XCTAssertEqual(deck, expectedDeck)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchNonExistingDeckById() throws {
        let expectation = expectation(description: "fetch a single Deck")
        
        sut.fetchDeckById(DeckDummy.dummy.id)
            .sink {
                XCTAssertEqual($0, .failure(.failedFetching))
                expectation.fulfill()
            } receiveValue: { deck in
                
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func createStandardDeck() throws {
        try sut.createDeck(DeckDummy.dummy, cards: [])
    }
    
    func testFetchDecksByIds() throws {
        let expectation = expectation(description: "fetch multiple decks by ids")
        
        let decks = createMultipleDecks().sorted { d1, d2 in d1.name < d2.name }
        try saveMultipleDecks(decks)
        
        sut.fetchDecksByIds(decks.map(\.id))
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { fetchedDecks in
                XCTAssertEqual(decks, fetchedDecks)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchNonExistingDecksByIds() throws {
        let expectation = expectation(description: "fetch multiple decks by ids")
        
        let decks = createMultipleDecksSorted()
        
        sut.fetchDecksByIds(decks.map(\.id))
            .sink {
                XCTAssertEqual($0, .failure(.failedFetching))
                expectation.fulfill()
                
            } receiveValue: { values in
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func createMultipleDecks(ids: [UUID] = UUIDDummy.dummy) -> [Deck] {
        ids.map(DeckDummy.newDummy(with:))
    }
    
    private func createMultipleDecksSorted(ids: [UUID] = UUIDDummy.dummy) -> [Deck] {
        createMultipleDecks(ids: ids).sorted { d1, d2 in d1.name < d2.name }
    }
    
    private func saveMultipleDecks(_ decks: [Deck]) throws {
        try decks.forEach { deck in
            try sut.createDeck(deck, cards: [])
        }
    }
    
    func testDeckListener() throws {
        let expectation = expectation(description: "listen to decks list")
        
        var decks = createMultipleDecksSorted()
        try saveMultipleDecks(decks)
        
        var listenerCallsCount = 0
        let listenerExpectedCount = 1
        
        sut.deckListener()
            .sink { _ in
                
            } receiveValue: { receivedDecks in
                XCTAssertEqual(decks, receivedDecks)
                
                if listenerCallsCount == listenerExpectedCount {
                    expectation.fulfill()
                } else {
                    listenerCallsCount += 1
                }
            }
            .store(in: &cancellables)
        
        decks.append(DeckDummy.dummy)
        decks.sort { d1, d2 in d1.name < d2.name }
        
        try sut.createDeck(DeckDummy.dummy, cards: [])
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeckListenerWithEmptyDeckList() throws {
        let expectation = expectation(description: "listen to decks list")
        
        var decks: [Deck] = []
        
        var listenerCallsCount = 0
        let listenerExpectedCount = 1
        
        sut.deckListener()
            .sink { _ in
                
            } receiveValue: { receivedDecks in
                XCTAssertEqual(decks, receivedDecks)
                
                if listenerCallsCount == listenerExpectedCount {
                    expectation.fulfill()
                } else {
                    listenerCallsCount += 1
                }
            }
            .store(in: &cancellables)
        
        decks.append(DeckDummy.dummy)
        decks.sort { d1, d2 in d1.name < d2.name }
        
        try sut.createDeck(DeckDummy.dummy, cards: [])
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testCardListenerForDeck() throws {
        let decks = createMultipleDecks()
        try saveMultipleDecks(decks)
        
        var correctCards = createMultipleCardsSorted(into: decks.first!)
        try saveMultipleCards(correctCards, into: decks.first!)
        
        let otherCards = createMultipleCardsSorted(ids: [UUID(), UUID(), UUID()] , into: decks.last!)
        try saveMultipleCards(otherCards, into: decks.last!)
        
        var listenerCallsCount = 0
        let listenerExpectedCount = 1
        
        let expectation = expectation(description: "listen to cards of first deck")
        
        sut.cardListener(forId: decks.first!.id)
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: {[unowned self] cards in
                XCTAssertEqual(cards.count, correctCards.count)
                
                zip(
                    cards.sorted { d1, d2 in d1.id.uuidString < d2.id.uuidString },
                    correctCards.sorted { d1, d2 in d1.id.uuidString < d2.id.uuidString }
                )
                    .forEach { c1, c2 in self.assertCard(card1: c1, card2: c2) }
                
                if listenerCallsCount == listenerExpectedCount {
                    expectation.fulfill()
                } else {
                    listenerCallsCount += 1
                }
            }
            .store(in: &cancellables)
        
        let wrongCard = CardDummy.newDummyCard(UUID(), into: decks.last!)
        try sut.addCard(wrongCard, to: decks.last!)
        
        let correctCard = CardDummy.newDummyCard(UUID(), into: decks.first!)
        correctCards.append(correctCard)
        try sut.addCard(correctCard, to: decks.first!)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testCreateDeckWithoutCards() throws {
        let dummy = DeckDummy.dummy
        let count = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        XCTAssertEqual(0, count)
        
        try sut.createDeck(dummy, cards: [])
        
        let deck = try deckRepository.fetchEntityById(dummy.id)
        
        let transformer = DeckModelEntityTransformer()
        XCTAssertEqual(dummy, transformer.entityToModel(deck))
        
        let countResult = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        XCTAssertEqual(1, countResult)
    }
    
    func testCreateDeckWithCards() throws {
        var dummy = DeckDummy.dummy
        let cardDummy = CardDummy.dummy
        
        let count = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        XCTAssertEqual(0, count)
        
        try sut.createDeck(dummy, cards: [cardDummy])
        
        dummy.cardsIds.append(cardDummy.id)
        let transformer = DeckModelEntityTransformer()
        
        let deck = try deckRepository.fetchEntityById(dummy.id)
        XCTAssertEqual(deck.cards?.count, 1)
        XCTAssertEqual(dummy, transformer.entityToModel(deck))
        
        let countResult = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        XCTAssertEqual(1, countResult)
    }
    
    func testDeleteExistingDeckWithoutCards() throws {
        let dummy = DeckDummy.dummy
        
        try sut.createDeck(dummy, cards: [])
        
        let initialDeckCount = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        let initialCardCount = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(1, initialDeckCount)
        XCTAssertEqual(0, initialCardCount)
        
        try sut.deleteDeck(dummy)
        
        let resultDeckCount = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        let resultCardCount = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(0, resultDeckCount)
        XCTAssertEqual(0, resultCardCount)
    }
    
    func testDeleteExistingDeckWithCards() throws {
        let dummy = DeckDummy.dummy
        
        try sut.createDeck(dummy, cards: [CardDummy.dummy])
        
        let initialDeckCount = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        let initialCardCount = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(1, initialDeckCount)
        XCTAssertEqual(1, initialCardCount)
        
        try sut.deleteDeck(dummy)
        
        let resultDeckCount = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        let resultCardCount = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(0, resultDeckCount)
        XCTAssertEqual(0, resultCardCount)
    }
    
    func testDeleteNonExistingDeck() throws {
        let dummy = DeckDummy.dummy
        
        let initialDeckCount = try dataStorage.mainContext.count(for: DeckEntity.fetchRequest())
        let initialCardCount = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(0, initialDeckCount)
        XCTAssertEqual(0, initialCardCount)
        
        XCTAssertThrowsError(try sut.deleteDeck(dummy))
    }
    
    func testEditExistingDeck() throws {
        let dummy = DeckDummy.dummy
        try sut.createDeck(dummy, cards: [])
        
        var newDummy = dummy
        newDummy.name = "changed"
        
        try sut.editDeck(newDummy)
        
        let entity = try deckRepository.fetchEntityById(newDummy.id)
        let transformer = DeckModelEntityTransformer()
        XCTAssertEqual(newDummy, transformer.entityToModel(entity))
    }
    
    func testEditNonExistingDeck() throws {
        let dummy = DeckDummy.dummy
        
        var newDummy = dummy
        newDummy.name = "changed"
        
        XCTAssertThrowsError(try sut.editDeck(newDummy))
    }
    
    func testAddCardToExistingDeck() throws {
        let dummyDeck = DeckDummy.dummy
        try sut.createDeck(dummyDeck, cards: [])
        
        let card = CardDummy.dummy
        try sut.addCard(card, to: dummyDeck)
        
        let count = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(1, count)
        
        let entityDeck = try deckRepository.fetchEntityById(dummyDeck.id)
        XCTAssertEqual(1, entityDeck.cards?.count)
        
    }
    
    func testAddCardToNonExistingDeck() throws {
        let dummyDeck = DeckDummy.dummy
        
        let card = CardDummy.dummy
        XCTAssertThrowsError(try sut.addCard(card, to: dummyDeck))
    }
    
    
    func testRemoveExistingCardFromExistingDeck() throws {
        let dummyDeck = DeckDummy.dummy
        try sut.createDeck(dummyDeck, cards: [])
        
        let card = CardDummy.dummy
        try sut.addCard(card, to: dummyDeck)
        
        let count = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(1, count)
        
        let entityDeck = try deckRepository.fetchEntityById(dummyDeck.id)
        XCTAssertEqual(1, entityDeck.cards?.count)
        
        try sut.removeCard(card, from: dummyDeck)
        
        XCTAssertEqual(0, entityDeck.cards?.count)
    }
    
    func testRemoveNonExistingCardFromExistingDeck() throws {
        let dummyDeck = DeckDummy.dummy
        try sut.createDeck(dummyDeck, cards: [])
        
        let card = CardDummy.dummy
        
        XCTAssertThrowsError(try sut.removeCard(card, from: dummyDeck))
    }
    
    func testFetchingExistingCard() throws {
        let deck = DeckDummy.dummy
        let card = createMultipleCards(ids: [UUIDDummy.dummy.first!], into: deck).first!
        try saveMultipleCards([card], into: deck)
        
        let expectation = expectation(description: "fetch a single card")
        
        sut.fetchCardById(card.id)
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { fetchedCard in
                self.assertCard(card1: card, card2: fetchedCard)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func createMultipleCards(ids: [UUID] = UUIDDummy.dummy, into deck: Deck) -> [Card] {
        ids.map{ CardDummy.newDummyCard($0, into: deck) }
    }
    
    private func createMultipleCardsSorted(ids: [UUID] = UUIDDummy.dummy, into deck: Deck) -> [Card] {
        createMultipleCards(ids: ids, into: deck).sorted { d1, d2 in d1.woodpeckerCardInfo.step < d2.woodpeckerCardInfo.step }
    }
    
    private func saveMultipleCards(_ cards: [Card], into deck: Deck) throws {
        try sut.createDeck(deck, cards: [])
        
        try cards.forEach {
            try sut.addCard($0, to: deck)
        }
    }
    
    func testFetchingNonExistingCard() throws {
        let deck = DeckDummy.dummy
        let card = createMultipleCards(ids: [UUIDDummy.dummy.first!], into: deck).first!
        
        let expectation = expectation(description: "fetch a single Card")
        
        sut.fetchCardById(card.id)
            .sink {
                XCTAssertEqual($0, .failure(.failedFetching))
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchingMultipleExistingCards() throws {
        let expectation = expectation(description: "fetch multiple cards by ids")
        let deck = DeckDummy.dummy
        let cards = createMultipleCardsSorted(into: deck)
        try saveMultipleCards(cards, into: deck)
        
        sut.fetchCardsByIds(cards.map(\.id))
            .sink {
                XCTAssertEqual($0, .finished)
            } receiveValue: { fetchedCards in
                
                zip(cards, fetchedCards).forEach { card1, card2 in
                    self.assertCard(card1: card1, card2: card2)
                }
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func assertCard(card1: Card, card2: Card) {
        XCTAssertEqual(card1.id, card2.id)
        XCTAssertEqual(card1.datesLogs.lastEdit, card2.datesLogs.lastEdit)
        XCTAssertEqual(card1.datesLogs.createdAt, card2.datesLogs.createdAt)
        XCTAssertEqual(card1.datesLogs.lastAccess, card2.datesLogs.lastAccess)
        XCTAssertEqual(card1.woodpeckerCardInfo, card2.woodpeckerCardInfo)
        XCTAssertEqual(card2.deckID, card2.deckID)
        XCTAssertEqual(card1.history, card2.history)
        
        XCTAssertEqual(NSAttributedString(card1.front).string, NSAttributedString(card2.front).string)
        XCTAssertEqual(NSAttributedString(card1.back).string, NSAttributedString(card2.back).string)
        
    }
    
    func testFetchingMultipleNonExistingCards() throws {
        let expectation = expectation(description: "fetch multiple card by ids")
        let deck = DeckDummy.dummy
        let cards = createMultipleCardsSorted(into: deck)
        
        sut.fetchCardsByIds(cards.map(\.id))
            .sink {
                XCTAssertEqual($0, .failure(.failedFetching))
                expectation.fulfill()
            } receiveValue: { _ in
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeletingCard() throws {
        let card = CardDummy.dummy
        let deck = DeckDummy.dummy
        
        try sut.createDeck(deck, cards: [card])
        
        let deckEntity = try deckRepository.fetchEntityById(deck.id)
        let initialCardCount = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        
        XCTAssertEqual(1, deckEntity.cards?.count)
        XCTAssertEqual(1, initialCardCount)
        
        try sut.deleteCard(card)
        
        let resultCardCount = try dataStorage.mainContext.count(for: CardEntity.fetchRequest())
        XCTAssertEqual(0, deckEntity.cards?.count)
        XCTAssertEqual(0, resultCardCount)
    }
    
    func testDeletingNonExisitingCard() throws {
        let card = CardDummy.dummy
        
        XCTAssertThrowsError(try sut.deleteCard(card))
    }
    
    func testEditingNonExistingCard() throws {
        let card = CardDummy.dummy
        
        var newDummy = card
        newDummy.woodpeckerCardInfo.streak = 4
        
        XCTAssertThrowsError(try sut.editCard(newDummy))
    }
    
    func testEditingCard() throws {
        let dummy = DeckDummy.dummy
        let card = CardDummy.dummy
        try sut.createDeck(dummy, cards: [card])
        
        var newDummy = card
        newDummy.woodpeckerCardInfo.streak = 4
        
        try sut.editCard(newDummy)
        
        let entity = try cardRepository.fetchEntityById(newDummy.id)
        let transformer = CardModelEntityTransformer()
        assertCard(card1: newDummy, card2: transformer.entityToModel(entity)!)
    }
    
    func testCreateSession() throws {
        var deck = DeckDummy.dummy
        let cards = createMultipleCardsSorted(into: deck)
        
        try sut.createDeck(deck, cards: cards)
        
        deck.cardsIds = cards.map(\.id)
        
        var session = createDummySession(deck: deck)
        var result = try addSessionToStorage(session: session, deck: deck)
        
        session.cardIds.sort { u1, u2 in
            u1.uuidString < u2.uuidString
        }
        
        result.cardIds.sort { u1, u2 in
            u1.uuidString < u2.uuidString
        }
        
        XCTAssertEqual(result, session)
    }
    
    func testEditSession() throws {
        var deck = DeckDummy.dummy
        let cards = createMultipleCardsSorted(into: deck)
        
        try sut.createDeck(deck, cards: cards)
        
        deck.cardsIds = cards.map(\.id)
        
        let session = createDummySession(deck: deck)
        
        var newSession = SessionDummy.dummy
        newSession.deckId = deck.id
        newSession.cardIds = deck.cardsIds
        newSession.date = Date(timeIntervalSince1970: 67865)
        
        try sut.createSession(session, for: deck)
        try sut.editSession(newSession)
        
        let entity = try sessionRepository.fetchEntityById(session.id)
        var result = sessionTransformer.entityToModel(entity)
        
        newSession.cardIds.sort { u1, u2 in
            u1.uuidString < u2.uuidString
        }
        
        result!.cardIds.sort { u1, u2 in
            u1.uuidString < u2.uuidString
        }
        
        XCTAssertEqual(result, newSession)
    }
    
    func testDeleteSession() throws {
        var deck = DeckDummy.dummy
        let cards = createMultipleCardsSorted(into: deck)
        
        try sut.createDeck(deck, cards: cards)
        
        deck.cardsIds = cards.map(\.id)
        
        let session = createDummySession(deck: deck)
        
        try sut.createSession(session, for: deck)
        
        let initialCount = try dataStorage.mainContext.count(for: SessionEntity.fetchRequest())
        XCTAssertEqual(1, initialCount)
        
        try sut.deleteSession(session, for: deck)
        
        let result = try dataStorage.mainContext.count(for: SessionEntity.fetchRequest())
        XCTAssertEqual(0, result)
    }
    
    func testAddCardsToSession() throws {
        var deck = DeckDummy.dummy
        let cards = createMultipleCardsSorted(into: deck)
        
        try sut.createDeck(deck, cards: cards)
        
        let session = createDummySession(deck: deck)
        
        try sut.createSession(session, for: deck)
        
        let entity = try sessionRepository.fetchEntityById(session.id)
        
        XCTAssertEqual(entity.cards?.count, 0)
        
        try sut.addCardsToSession(session, cards: cards)
        
        XCTAssertNotEqual(entity.cards?.count, 0)
    }
    
    func testRemoveCardsFromSession() throws {
        var deck = DeckDummy.dummy
        let cards = createMultipleCardsSorted(into: deck)
        
        try sut.createDeck(deck, cards: cards)
        
        deck.cardsIds = cards.map(\.id)
        
        let session = createDummySession(deck: deck)
        
        try sut.createSession(session, for: deck)
        
        let entity = try sessionRepository.fetchEntityById(session.id)
        
        XCTAssertNotEqual(entity.cards?.count, 0)
        
        try sut.removeCardsFromSession(session, cards: cards)
        
        XCTAssertEqual(entity.cards?.count, 0)
    }
    
    private func createDummySession(deck: Deck) -> Session {
        
        var session = SessionDummy.dummy
        session.deckId = deck.id
        session.cardIds = deck.cardsIds
        
        return session
    }
    
    private func addSessionToStorage(session: Session, deck: Deck) throws -> Session {
        
        try sut.createSession(session, for: deck)
        
        let entity = try sessionRepository.fetchEntityById(session.id)
        let result = sessionTransformer.entityToModel(entity)
        
        return result!
    }
}
