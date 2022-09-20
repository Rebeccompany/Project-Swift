//
//  CollectionModelEntityTransformeTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/08/22.
//

import XCTest
@testable import Storage
import Models

class CollectionModelEntityTransformeTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    var sut: CollectionModelEntityTransformer!

    override func setUp() {
        dataStorage = DataStorage(StoreType.inMemory)
        sut = .init()
    }
    
    override func tearDown() {
        dataStorage = nil
        sut = nil
    }
    
    func testModelToEntity() throws {
        let model = DeckCollectionDummy.dummy
        
        _ = sut.modelToEntity(model, on: dataStorage.mainContext)
        try dataStorage.save()
        
        let saved = try dataStorage.mainContext.fetch(CollectionEntity.fetchRequest()).first!
        
        XCTAssertEqual(model.id, saved.id)
        XCTAssertEqual(model.name, saved.name)
        XCTAssertEqual(model.icon, model.icon)
        XCTAssertEqual(model.datesLogs.createdAt, saved.createdAt)
        XCTAssertEqual(model.datesLogs.lastEdit, saved.lastEdit)
        XCTAssertEqual(model.datesLogs.lastAccess, saved.lastAccess)
        
    }
    
    func testEntityToModel() throws {
        let model = DeckCollectionDummy.dummy
        
        _ = sut.modelToEntity(model, on: dataStorage.mainContext)
        try dataStorage.save()
        
        let saved = try dataStorage.mainContext.fetch(CollectionEntity.fetchRequest()).first!
        
        let savedModel = sut.entityToModel(saved)
        
        XCTAssertEqual(model, savedModel)
    }

}
