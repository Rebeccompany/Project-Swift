//
//  Dependency.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//

import Foundation

@propertyWrapper
public struct Dependency<T> {
    
    private let keyPath: WritableKeyPath<Habitat, T>
    
    public init(_ keyPath: WritableKeyPath<Habitat, T>) {
        self.keyPath = keyPath
    }
    
    public var wrappedValue: T {
        get { Habitat[keyPath] }
        set { Habitat[keyPath] = newValue }
    }
}
