//
//  File.swift
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
        sut = .init(session: EndpointResolverMock(), dateHandler: <#T##DateHandlerProtocol#>)
    }
    
    override func tearDown() {
        sut = nil
        
    }
    
}
