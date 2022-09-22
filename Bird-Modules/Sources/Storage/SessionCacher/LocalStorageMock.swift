//
//  File.swift
//  
//
//  Created by Marcos Chevis on 06/09/22.
//

import Foundation

public class LocalStorageMock: LocalStorageService {
    var dict: [String: Any] = [:]
    
    public init() {
        
    }
    
    public func object(forKey: String) -> Any? {
        dict[forKey]
    }
    
    public func string(forKey: String) -> String? {
        object(forKey: forKey) as? String
    }
    
    public func set(_ value: Any?, forKey: String) {
        dict[forKey] = value
    }
    
    
}
