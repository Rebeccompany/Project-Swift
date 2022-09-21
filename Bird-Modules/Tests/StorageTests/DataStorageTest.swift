//
//  DataStorageTest.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/08/22.
//
@testable import Storage
import XCTest
import Models

class DataStorageTest: XCTestCase {
    
    var sut: DataStorage! = nil

    override func setUp() {
        sut = .init(StoreType.inMemory)
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testSave() throws {
        let request = CollectionEntity.fetchRequest()
        
        let initialResult = try sut.mainContext.count(for: request)
        XCTAssertEqual(0, initialResult)
        
        let collectionEntity = CollectionEntity(context: sut.mainContext)
        collectionEntity.id = UUID()
        collectionEntity.lastAccess = Date()
        collectionEntity.lastEdit = Date()
        collectionEntity.createdAt = Date()
        collectionEntity.name = "Dummy Collection"
        collectionEntity.icon = IconNames.atom.rawValue
        
        try sut.save()
        
        let result = try sut.mainContext.count(for: request)
        XCTAssertEqual(1, result)
    }

}
