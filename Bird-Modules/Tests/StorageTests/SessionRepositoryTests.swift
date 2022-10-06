//
//  SessionRepositoryTests.swift
//  
//
//  Created by Nathalia do Valle Papst on 05/10/22.
//

import XCTest
@testable import Storage
import Combine
import Models
import Utils

final class SessionRepositoryTests: XCTestCase {
    
    var sut: SessionRepository! = nil
    var deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>! = nil
    var cardRepository: Repository<Card, CardEntity, CardModelEntityTransformer>! = nil
    var dataStorage: DataStorage! = nil
    var sessionRepository: Repository<Session, SessionEntity, SessionModelEntityTransformer>! = nil
    var dateHandler: DateHandlerMock! = nil
    
    override func setUp() {
        self.dataStorage = DataStorage(.inMemory)
        self.dateHandler = DateHandlerMock()
        self.sessionRepository = Repository(transformer: SessionModelEntityTransformer(), dataStorage)
        self.deckRepository = Repository(transformer: DeckModelEntityTransformer(), dataStorage)
        self.cardRepository = Repository(transformer: CardModelEntityTransformer(), dataStorage)
        self.sut = SessionRepository(repository: sessionRepository, dateHandler: dateHandler, deckRepository: deckRepository, cardsRepository: cardRepository)
    }
    
    override func tearDown() {
        self.sut = nil
        self.cardRepository = nil
        self.deckRepository = nil
        self.dataStorage = nil
        self.sessionRepository = nil
        self.dateHandler = nil
    }
    
    func testSetCurrentSession() throws {
        let deck = try deckRepository.create(DeckDummy.dummy)
        let card = try cardRepository.create(CardDummy.dummy)
        
        deck.addToCards(card)
        
        try dataStorage.save()
        
        let sessionDummy = Session(cardIds: [card.id!], date: dateHandler.today, deckId: deck.id!, id: SessionDummy.dummy.id)
        
        try sut.setCurrentSession(session: sessionDummy)
        
        let session = try sessionRepository.fetchEntityById(sessionDummy.id)
        XCTAssertEqual(sessionDummy, SessionModelEntityTransformer().entityToModel(session))
    }
    
    func testCurrentSessionIsNil() throws {
        let deck = try deckRepository.create(DeckDummy.dummy)
        
        let session = sut.currentSession(for: deck.id!)
        
        XCTAssertNil(session)
    }
    
    func testCurrentSessionWithSession() throws {
        let deck = try deckRepository.create(DeckDummy.dummy)
        let card = try cardRepository.create(CardDummy.dummy)
        
        deck.addToCards(card)
        
        try dataStorage.save()
        
        let sessionDummy = Session(cardIds: [card.id!], date: dateHandler.today, deckId: deck.id!, id: SessionDummy.dummy.id)
        
        try sut.setCurrentSession(session: sessionDummy)
        
        let newSession = sut.currentSession(for: deck.id!)
        
        XCTAssertEqual(sessionDummy, newSession)
    }
    
    func testDeleteSessionWithDeck() throws {
        let deck = try deckRepository.create(DeckDummy.dummy)
        let card = try cardRepository.create(CardDummy.dummy)
        
        deck.addToCards(card)
        
        try dataStorage.save()
        
        let sessionDummy = Session(cardIds: [card.id!], date: dateHandler.today, deckId: deck.id!, id: SessionDummy.dummy.id)
        
        try sut.setCurrentSession(session: sessionDummy)
        
        try deckRepository.delete(DeckDummy.dummy)
        
        XCTAssertNil(sut.currentSession(for: DeckDummy.dummy.id))
    }
    
    func testEditSession() throws {
        let deck = try deckRepository.create(DeckDummy.dummy)
        let card = try cardRepository.create(CardDummy.dummy)
        
        deck.addToCards(card)
        
        try dataStorage.save()
        
        var sessionDummy = Session(cardIds: [card.id!], date: dateHandler.today, deckId: deck.id!, id: SessionDummy.dummy.id)
        
        try sut.setCurrentSession(session: sessionDummy)
        
        sessionDummy.cardIds.remove(at: 0)
        sessionDummy.date = dateHandler.dayAfterToday(1)
        do {
            try sut.editSession(sessionDummy)
        } catch {
            print(error)
        }
        
        print(sessionDummy, sut.currentSession(for: deck.id!), "ghukygy")
        
        XCTAssertEqual(sessionDummy, sut.currentSession(for: deck.id!))
    }
}
