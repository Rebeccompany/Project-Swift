//
//  HabitatKey.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//

import Foundation

public protocol HabitatKey {
    
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}
