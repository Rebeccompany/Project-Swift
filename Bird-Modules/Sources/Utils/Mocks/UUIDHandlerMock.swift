//
//  UUIDHandlerMock.swift
//  
//
//  Created by Rebecca Mello on 08/09/22.
//

import Foundation

public class UUIDHandlerMock: UUIDGeneratorProtocol {
    public init() {}
    
    public var lastCreatedID: UUID?
    
    public func newId() -> UUID {
        let newID = UUID()
        lastCreatedID = newID
        return newID
    }
    
    
}
