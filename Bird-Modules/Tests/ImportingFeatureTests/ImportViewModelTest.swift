//
//  ImportViewModelTest.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/10/22.
//

import XCTest
@testable import ImportingFeature
import Storage
import Habitat
import Utils

final class ImportViewModelTest: XCTestCase {
    
    var repository: DeckRepositoryMock!
    var sut: ImportViewModel!
    var dateHandler: DateHandlerMock!
    var uuidGenerator: UUIDHandlerMock!

    override func setUp() {
        repository = DeckRepositoryMock()
        setupHabitatForIsolatedTesting(deckRepository: repository)
        dateHandler = DateHandlerMock()
        uuidGenerator = UUIDHandlerMock()
        sut = ImportViewModel()
    }
    
    override func tearDown() {
        sut = nil
        dateHandler = nil
        uuidGenerator = nil
        repository = nil
    }
    
    func testSaveNewCards() throws {
        let cards = try DeckConverter()
            .convert(DummyCSVData.dummyData.first!)
            .map {
                ImportedCardInfoTransformer.transformToCard($0, deckID: repository.decks.first!.id, cardColor: .red, dateHandler: dateHandler, uuidHandler: uuidGenerator)!
            }
        
        let cardsInitialCount = repository.decks.first!.cardCount
        
        sut.save(cards, to: repository.decks.first!)
        
        XCTAssertEqual(cards.count, repository.decks.first!.cardCount - cardsInitialCount)
    }

}
