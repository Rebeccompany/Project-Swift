//
//  NewCollectionViewModelTests.swift
//  
//
//  Created by Caroline Taus on 08/09/22.
//

import XCTest
@testable import NewCollectionFeature
import Storage
import Models

class NewCollectionViewModelTests: XCTestCase {

    var sut: NewCollectionViewModel!
    var collectionRepository: CollectionRepositoryMock!
    
    override func setUp() {
        collectionRepository = CollectionRepositoryMock()
        sut = NewCollectionViewModel(colors: CollectionColor.allCases, collectionRepository: collectionRepository)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testCreateCollectionSuccessfully() {
        sut.collectionName = "Coleção"
        sut.currentSelectedColor = CollectionColor.red
        sut.createCollection()
        
        
    }

}
