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
    var collectionIDs: [UUID]!
    
    override func setUp() {
        deckRepository = DeckRepositoryMock()
        sut = NewDeckViewModel(colors: CollectionColor.allCases, icons: IconNames.allCases, deckRepository: deckRepository, collectionId: collectionIDs)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCreateDeckSuccessfully() {
        sut.deckName = "Name"
        sut.currentSelectedColor = CollectionColor.red
        sut.currentSelectedIcon = IconNames.book
        sut.createDeck()
    }

}
