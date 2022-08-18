//
//  File.swift
//  
//
//  Created by Rebecca Mello on 18/08/22.
//

@testable import ImportingFeature
import XCTest

final class DeckConverterTests: XCTestCase {
    var sut: DeckConverter! = nil
    
    var dummyData: Data = """
    front;back;tags;deck
    Ausculta dos Batimentos Cardiofetais;"Pinard - 20 semanas&nbsp;<br>Sonar - 10-12 semanas";;Obstetro - Diagnostico de gravidez
    "Calculo da idade gestacional&nbsp;";"Intervalo de tempo entre a data da ultima menstruacao e a data atual (do parto) em semanas e dias&nbsp;";;Obstetro - Diagnostico de gravidez
    """.data(using: .utf8)!
    
    override func setUp() async throws {
        sut = DeckConverter()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testDecodeCSV() throws {
        let deck = try sut.convert(dummyData)
    }
}
