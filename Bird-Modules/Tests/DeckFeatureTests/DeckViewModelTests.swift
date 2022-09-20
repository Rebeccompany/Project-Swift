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

final class DeckViewModelTests: XCTestCase {
    
    var sut: DeckViewModel!
    var deckRepository: DeckRepositoryMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        sut = DeckViewModel(deck: deckRepository.decks[0], deckRepository: deckRepository)
        cancellables = .init()
        sut.startup()
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
        cancellables.forEach({$0.cancel()})
        cancellables = nil
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
        XCTAssertTrue(sut.canStudy)
    }
    
    func testCanStudyFalse() {
        let cards: [Card] = [Card(id: UUID(), front: "", back: "", color: .red, datesLogs: DateLogs(), deckID: UUID(uuidString: "5c27ad86-b84a-41cf-ab97-bb45586adfbd")!, woodpeckerCardInfo: WoodpeckerCardInfo(step: 1, isGraduated: false, easeFactor: 2.5, streak: 0, interval: 10000, hasBeenPresented: true), history: [])]
        sut = DeckViewModel(deck: Deck(id: UUID(uuidString: "5c27ad86-b84a-41cf-ab97-bb45586adfbd")!, name: "Teste Deck", icon: "pencil", color: .red, collectionsIds: [UUID()], cardsIds: cards.map{$0.id}))
        sut.startup()

        XCTAssertFalse(sut.canStudy)
    }

}
