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

final class ExternalDeckServiceTests: XCTestCase {
    var sut: ExternalDeckService!
    var resolverMock: EndpointResolverMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        resolverMock = EndpointResolverMock()
        cancellables = .init()
        sut = ExternalDeckService(session: resolverMock)
    }
    
    override func tearDown() {
        resolverMock = nil
        sut = nil
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = nil
    }
    
    func testSuccessCall() {
        let expectedResult = resolverMock.externalSection
        resolverMock.data = resolverMock.externalSectionData
        
        let expectation = expectation(description: "Return expected result from api call")
        
        sut.getDeckFeed()
            .assertNoFailure()
            .sink { section in
                XCTAssertEqual(expectedResult, section)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
