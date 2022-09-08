////
////  StudyViewModelTests.swift
////  
////
////  Created by Marcos Chevis on 06/09/22.
////
//
//import XCTest
//@testable import StudyFeature
//import Storage
//import Models
//import Combine
//
//class StudyViewModelTests: XCTestCase {
//    
//    var sut: StudyViewModel!
//    var localStorage: LocalStorageMock!
//    var deckRepository: DeckRepositoryMock!
//    var deck: Deck!
//    var sessionCacher: SessionCacher!
//    var dateHandler: DateHandlerProtocol!
//    var cancellables: Set<AnyCancellable>!
//
//    override func setUpWithError() throws {
//        deckRepository = DeckRepositoryMock()
//        localStorage = LocalStorageMock()
//        sessionCacher = SessionCacher(storage: localStorage)
//        deck = deckRepository.decks.first
//        dateHandler = DateHandlerMock()
//        sut = .init(deckRepository: deckRepository, sessionCacher: sessionCacher, deck: deck, dateHandler: dateHandler)
//        cancellables = .init()
//    }
//
//    override func tearDownWithError() throws {
//        deckRepository = nil
//        localStorage = nil
//        sessionCacher = nil
//        deck = nil
//        sut = nil
//        cancellables.forEach { $0.cancel() }
//        cancellables = nil
//        dateHandler = nil
//    }
//    
//    func testStartupWithExistingSession() {
//        let cardIds = deckRepository.cards.enumerated().filter { $0.offset < 3 }.map(\.element.id)
//        let session = Session(cardIds: cardIds, date: dateHandler.today, deckId: deck.id)
//        sessionCacher.setCurrentSession(session: session)
//        
//        sut.startup()
//        let expectation = expectation(description: "fetch cards")
//        sut.$cards.sink {[unowned self] cards in
//            let first3Cards = self.deckRepository.cards.enumerated().filter { $0.offset < 3 }.map(\.element)
//            XCTAssertEqual(cards, first3Cards)
//            expectation.fulfill()
//        }
//        .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 1)
//    }
//    
//    func testStartupWithNewSession() {
//        XCTAssertEqual(sut.cards, [])
//        sut.startup()
//        let expectation = expectation(description: "fetch cards")
//        sut.$cards.sink { cards in
//            print(cards)
//            XCTAssertEqual(cards.sorted(by: self.sortByDate), self.deckRepository.cards.sorted(by: self.sortByDate))
//            expectation.fulfill()
//        }
//        .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 1)
//    }
//    
//    func testDidCreateNewSessionOnStartup() {
//        XCTAssertNil(sessionCacher.currentSession(for: deck.id))
//        sut.startup()
//        
//        let expectation = expectation(description: "did handle events correctly")
//        
//        let expectedSession = Session(cardIds: deck.cardsIds.sorted(by: { $0.uuidString > $1.uuidString } ), date: dateHandler.today, deckId: deck.id)
//        
//        sut.$cards.sink {[unowned self] cards in
//            var session = self.sessionCacher.currentSession(for: self.deck.id)
//            let ids = session?.cardIds ?? []
//            session?.cardIds = ids.sorted(by: { $0.uuidString > $1.uuidString })
//            XCTAssertEqual(expectedSession, session)
//            expectation.fulfill()
//        }
//        .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 1)
//    }
//
//    
//    func sortByDate(d0: Card, d1: Card) -> Bool {
//        return d0.id.uuidString > d1.id.uuidString
//    }
//}
