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
    var deckRepository: DeckRepositoryMock!
    var sessionCacher: SessionCacher!
    var dateHandler: DateHandlerProtocol!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        sessionCacher = SessionCacher(storage: LocalStorageMock())
        dateHandler = DateHandlerMock()
        setupHabitatForIsolatedTesting(deckRepository: deckRepository, dateHandler: dateHandler, sessionCacher: sessionCacher)
        sut = DeckViewModel()
        cancellables = .init()
        sut.startup(deckRepository.decks[0])
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
    }
    
    func testStartup() throws {
        let cardExpectation = expectation(description: "card reacting to Repository Action")
        
        try deckRepository.addCard(Card(id: UUID(), front: AttributedString(), back: AttributedString(), color: .red, datesLogs: DateLogs(), deckID: deckRepository.decks.first!.id, woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false), history: []), to: deckRepository.decks.first!)
        
        sut.$cards
            .sink {[unowned self] cards in
                XCTAssertEqual(cards, self.deckRepository.cards.sorted {c1, c2 in c1.datesLogs.createdAt > c2.datesLogs.createdAt})
                cardExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [cardExpectation], timeout: 1)
    }

    func testDeleteFlashcard() throws {
        
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsCard = deckRepository.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsCard)

        try sut.deleteFlashcard(card: deckRepository.cards[0])

        let deletedDeck = deckRepository.cards.contains(where: {
            $0.id == id
        })

        XCTAssertFalse(deletedDeck)
    }
    
    func testSearchCardFront() {
        sut.searchFieldContent = "frente"
        
        let count = sut.cardsSearched.count
        
        XCTAssertEqual(count, deckRepository.cards.count)
    }
    
    func testSearchCardBack() {
        sut.searchFieldContent = "tras"
        
        let count = sut.cardsSearched.count
        
        XCTAssertEqual(count, deckRepository.cards.count)
    }
    
    func testSearchNoResults() {
        sut.searchFieldContent = "teste"
        
        let count = sut.cardsSearched.count
        
        XCTAssertEqual(count, 0)
    }
    
    func testCanStudyTrue() {
        XCTAssertTrue(sut.checkIfCanStudy(deckRepository.decks[0]))
    }
    
    func testCanStudyFalse() {
        
        sut = DeckViewModel()
        sut.startup(deckRepository.decks[2])

        XCTAssertFalse(sut.checkIfCanStudy(deckRepository.decks[2]))
    }
    
    func testCheckIfcanStudyWithSession() {
        let session = Session(cardIds: deckRepository.decks[0].cardsIds, date: dateHandler.today, deckId: deckRepository.decks[0].id)
        sessionCacher.setCurrentSession(session: session)
        sut.startup(deckRepository.decks[0])
        XCTAssertTrue(sut.checkIfCanStudy(deckRepository.decks[0]))
    }
    
    func testCheckIfcanStudyWithEmptySession() {
        let session = Session(cardIds: deckRepository.decks[2].cardsIds, date: dateHandler.today, deckId: deckRepository.decks[2].id)
        sessionCacher.setCurrentSession(session: session)
        sut.startup(deckRepository.decks[2])
        XCTAssertFalse(sut.checkIfCanStudy(deckRepository.decks[2]))
    }

}
