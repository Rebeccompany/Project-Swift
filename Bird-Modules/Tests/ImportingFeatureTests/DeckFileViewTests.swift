//
//  DeckFileViewTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import XCTest
import SwiftUI
@testable import ImportingFeature

class DeckFileViewTests: XCTestCase {
    
    var decodeFiles: [ImportedCardInfo] = []
    private var sut: DeckFilePicker! = nil
    private var viewModel: CSVPickerViewModel! = nil

    override func setUp() {
        viewModel = CSVPickerViewModel()
        let binding = Binding<[ImportedCardInfo]?> {
            self.decodeFiles
        } set: { [self] values in
            decodeFiles = values ?? []
        }
        sut = DeckFilePicker(selectedData: binding, viewModel: viewModel)
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
        super.tearDown()
    }

//    func testViewBinding() throws {
//        viewModel.fileContent = DummyCSVData.dummyData[0]
//        XCTAssertFalse(decodeFiles.isEmpty)
//    }
}
