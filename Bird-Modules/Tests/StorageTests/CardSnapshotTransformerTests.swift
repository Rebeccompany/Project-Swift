//
//  CardSnapshotTransformerTests.swift
//  
//
//  Created by Marcos Chevis on 05/10/22.
//

import XCTest
@testable import Storage
import Models
import Utils
import CoreData

class CardSnapshotTransformerTests: XCTestCase {
    var sut: CardSnapshotTransformer!
    var dateHandler: DateHandlerProtocol!
    var dataStorage: DataStorage!
    
    override func setUp() {
        sut = CardSnapshotTransformer()
        dateHandler = DateHandlerMock()
        dataStorage = DataStorage(.inMemory)
    }
    
    override func tearDown() {
        sut = nil
        dateHandler = nil
    }
    
    func testModelToEntity() {
        let model = CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo( hasBeenPresented: false), userGrade: .correct, timeSpend: 10, date: dateHandler.today)
        
        let entity = sut.modelToEntity(model, on: dataStorage.mainContext)
        
        XCTAssertEqual(model.woodpeckerCardInfo.easeFactor, entity.easeFactor)
        XCTAssertEqual(model.woodpeckerCardInfo.hasBeenPresented, entity.hasBeenPresented)
        XCTAssertEqual(model.woodpeckerCardInfo.interval, Int(entity.interval))
        XCTAssertEqual(model.woodpeckerCardInfo.isGraduated, entity.isGraduated)
        XCTAssertEqual(model.woodpeckerCardInfo.step, Int(entity.step))
        XCTAssertEqual(model.woodpeckerCardInfo.streak, Int(entity.streak))
        
        
        XCTAssertEqual(model.userGrade, UserGrade(rawValue: Int(entity.userGrade)))
        XCTAssertEqual(model.timeSpend, entity.timeSpend)
        XCTAssertEqual(model.date, entity.date)
    }
    
    func testEntityToModel() {
        let oldModel = CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo( hasBeenPresented: false), userGrade: .correct, timeSpend: 10, date: dateHandler.today)
        let entity = sut.modelToEntity(oldModel, on: dataStorage.mainContext)
        let model = sut.entityToModel(entity)!
        
        XCTAssertEqual(model.woodpeckerCardInfo.easeFactor, entity.easeFactor)
        XCTAssertEqual(model.woodpeckerCardInfo.hasBeenPresented, entity.hasBeenPresented)
        XCTAssertEqual(model.woodpeckerCardInfo.interval, Int(entity.interval))
        XCTAssertEqual(model.woodpeckerCardInfo.isGraduated, entity.isGraduated)
        XCTAssertEqual(model.woodpeckerCardInfo.step, Int(entity.step))
        XCTAssertEqual(model.woodpeckerCardInfo.streak, Int(entity.streak))
        
        
        XCTAssertEqual(model.userGrade, UserGrade(rawValue: Int(entity.userGrade)))
        XCTAssertEqual(model.timeSpend, entity.timeSpend)
        XCTAssertEqual(model.date, entity.date)
    }
}
