//
//  UUIDGenerator.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/09/22.
//

import Foundation

public protocol UUIDGeneratorProtocol {
    func newId() -> UUID
}

public struct UUIDGenerator: UUIDGeneratorProtocol {
    public init() {}
    
    public func newId() -> UUID {
        UUID()
    }
}
