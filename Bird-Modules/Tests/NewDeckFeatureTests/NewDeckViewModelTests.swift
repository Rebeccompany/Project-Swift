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

class NewDeckViewModelTests: XCTestCase {

    var sut: NewDeckViewModel!
    var deckRepository: DeckRepositoryMock!
    var dateHandlerMock: DateHandlerMock!
    var uuidHandler: UUIDHandlerMock!
    
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        dateHandlerMock = DateHandlerMock()
        uuidHandler = UUIDHandlerMock()
        
        sut = NewDeckViewModel(colors: CollectionColor.allCases,
                               icons: IconNames.allCases,
                               deckRepository: deckRepository,
                               collectionId: [],
                               dateHandler: dateHandlerMock,
                               uuidGenerator: uuidHandler
        )
    }
    
    override func tearDown() {
        sut = nil
        deckRepository = nil
        dateHandlerMock = nil
        uuidHandler = nil
    }
    
    func testCreateDeckSuccessfully() {
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.book
        sut.createDeck()
        
        let containsNewDeck = deckRepository.decks.contains(where: {
            $0.id == uuidHandler.lastCreatedID
        })
        
        XCTAssertTrue(containsNewDeck)
    }

}
