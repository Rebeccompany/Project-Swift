//
//  ImportTransformerTest.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/10/22.
//

import XCTest
@testable import ImportingFeature
import Utils
import Models

final class ImportTransformerTest: XCTestCase {

    var data: [ImportedCardInfo]!
    var dateHandler: DateHandlerMock!
    var uuidGenerator: UUIDHandlerMock!
    
    override func setUpWithError() throws {
        let converter = DeckConverter()
        uuidGenerator = UUIDHandlerMock()
        dateHandler = DateHandlerMock()
        data = try converter.convert(DummyCSVData.dummyData.first!)
    }
    
    override func tearDownWithError() throws {
        data = nil
        dateHandler = nil
        uuidGenerator = nil
    }
    
    func testTransform() {
        let deckId = uuidGenerator.newId()
        let cards = data.compactMap { ImportedCardInfoTransformer.transformToCard($0, deckID: deckId, cardColor: .red, dateHandler: dateHandler, uuidHandler: uuidGenerator) }
        XCTAssertFalse(cards.isEmpty)
        XCTAssertEqual(cards.count, data.count)
    }

}
