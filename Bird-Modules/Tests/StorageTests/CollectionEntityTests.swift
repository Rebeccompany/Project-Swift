//
//  CollectionEntityTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/08/22.
//

import XCTest
@testable import Storage
import Models

class CollectionEntityTests: XCTestCase {
    
    var dataStorage: DataStorage! = nil
    
    var collection: DeckCollection {
        DeckCollection(id: UUID(uuidString: "1ce212cd-7b81-4cbb-88ba-f57ca6161986")!,
                       name: "Coding",
                       iconPath: "chevron.down",
                       datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                           lastEdit: Date(timeIntervalSince1970: 0),
                                           createdAt: Date(timeIntervalSince1970: 0)),
                       decksIds: [])
    }

    override func setUp() {
        dataStorage = DataStorage(StoreType.inMemory)
    }
    
    override func tearDown() {
        dataStorage = nil
    }
    
    func testModelToEntity() throws {
        let model = collection
        
        _ = CollectionEntity(withData: model, on: dataStorage.mainContext)
        try dataStorage.save()
        
        let saved = try dataStorage.mainContext.fetch(CollectionEntity.fetchRequest()).first!
        
        XCTAssertEqual(model.id, saved.id)
        XCTAssertEqual(model.name, saved.name)
        XCTAssertEqual(model.iconPath, model.iconPath)
        XCTAssertEqual(model.datesLogs.createdAt, saved.createdAt)
        XCTAssertEqual(model.datesLogs.lastEdit, saved.lastEdit)
        XCTAssertEqual(model.datesLogs.lastAccess, saved.lastAccess)
        
    }
    
    func testEntityToModel() throws {
        let model = collection
        
        _ = CollectionEntity(withData: model, on: dataStorage.mainContext)
        try dataStorage.save()
        
        let saved = try dataStorage.mainContext.fetch(CollectionEntity.fetchRequest()).first!
        
        let savedModel = DeckCollection(entity: saved)
        
        XCTAssertEqual(model, savedModel)
    }

}
