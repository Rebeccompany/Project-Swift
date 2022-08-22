//
//  File.swift
//  
//
//  Created by Rebecca Mello on 18/08/22.
//

@testable import ImportingFeature
import XCTest

final class DeckConverterTests: XCTestCase {
    private var sut: DeckConverter! = nil
    
    override func setUp() {
        sut = DeckConverter()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testDecodeCSV() throws {
        try DummyCSVData
            .dummyData
            .forEach { data in
                let result = try sut.convert(data)
                print(result)
                XCTAssertFalse(result.isEmpty)
            }
    }
}
