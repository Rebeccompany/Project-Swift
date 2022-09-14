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
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        sut = DeckViewModel(deck: deckRepository.decks[0], deckRepository: deckRepository)
        
        sut.startup()
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
    }

    func testDeleteFlashcard() {
        
        let id = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")
        
        let containsCard = deckRepository.cards.contains(where: {
            $0.id == id
        })
        
        XCTAssertTrue(containsCard)

        sut.deleteFlashcard(card: deckRepository.cards[0])

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
        sut.searchFieldContent = "verso"
        
        let count = sut.cardsSearched.count
        
        XCTAssertEqual(count, deckRepository.cards.count)
    }
    
    func testSearchNoResults() {
        sut.searchFieldContent = "teste"
        
        let count = sut.cardsSearched.count
        
        XCTAssertEqual(count, 0)
    }

}
