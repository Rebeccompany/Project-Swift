//
//  UUIDHandlerMock.swift
//  
//
//  Created by Rebecca Mello on 08/09/22.
//

import Foundation
import Utils

class UUIDHandlerMock: UUIDGeneratorProtocol {
    var lastCreatedID: UUID? = nil
    
    func newId() -> UUID {
        let newID = UUID()
        lastCreatedID = newID
        return newID
    }
    
    
}