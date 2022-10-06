//
//  CardSnapshotRepositoryTests.swift
//  
//
//  Created by Marcos Chevis on 05/10/22.
//
import XCTest
@testable import Storage
import Models
import Utils

class CardSnapshotRepositoryTests: XCTestCase {
    var sut: CardSnapshotRepository!
    var dataStorage: DataStorage!
    var dateHandler: DateHandlerProtocol!
    
    override func setUp() {
        dataStorage = DataStorage(.inMemory)
        dateHandler = DateHandlerMock()
        sut = .init(transformer: CardSnapshotTransformer(), dataStorage: dataStorage)
    }
    
    override func tearDown() {
        sut = nil
        dataStorage = nil
        dateHandler = nil
    }
    
    func testCreateSnapshot() throws {
        let snap = CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo( hasBeenPresented: false), userGrade: .correct, timeSpend: 10, date: dateHandler.today)
        
        let _ = sut.create(snapshot:snap)
        
        let count = try dataStorage.mainContext.count(for: CardSnapshotEntity.fetchRequest())
        
        XCTAssertEqual(count, 1)
    }
}
