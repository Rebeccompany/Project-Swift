//
//  PuffinsTests.swift
//  
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation

import XCTest
@testable import Puffins
import Combine

final class PuffinsTests: XCTestCase {
    var endpointMock: EndpointMock!
    
    override func setUp() {
        endpointMock = EndpointMock()
        endpointMock.data = endpointMock.externalSectionData
    }
    
    override func tearDown() {
        endpointMock = nil
    }
    
    func testDataTaskError() throws {
        let response = try? endpointMock.dataTaskPublisher(for: )
        XCTAssertEqual(response, endpointMock.externalSectionData)
    }
}
