//
//  ExternalDeckServiceTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/11/22.
//

import Foundation
import XCTest
@testable import Puffins
import Utils

class ExternalDeckServiceTests: XCTestCase {
    var sut: ExternalDeckService!
    var endpoitResolver: EndpointResolverMock!
    var dateHandler: DateHandlerMock!
    
    override func setUp() {
        dateHandler = DateHandlerMock()
        sut = .init(session: EndpointResolverMock(), dateHandler: dateHandler)
    }
    
    override func tearDown() {
        sut = nil
        dateHandler = nil
    }
    
    func test7Hours() {
        XCTAssert(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval(-3600*7)))
    }
    
    func test9Hours() {
        XCTAssertFalse(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval(-3600*9)))
    }
    
    func test7Hours59Minute() {
        XCTAssertFalse(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval((-3600*8) + 60)))
    }
    
    func test8Hours1Minute() {
        XCTAssertFalse(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval((-3600*8) - 60)))
    }
    
    func test8Hours1Second() {
        XCTAssertFalse(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval((-3600*8) - 1)))
    }
    
    func test1Day() {
        XCTAssertFalse(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval((-86400))))
    }
    
    func test1Month() {
        XCTAssertFalse(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval((-86400*32))))
    }
    
    func test1Year() {
        XCTAssertFalse(sut.isInPast8Hours(date: dateHandler.today.addingTimeInterval((-86400*366))))
    }
    
}
