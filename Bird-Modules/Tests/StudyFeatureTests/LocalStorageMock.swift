//
//  File.swift
//  
//
//  Created by Marcos Chevis on 06/09/22.
//

import Foundation
import Storage

class LocalStorageMock: LocalStorageService {
    var dict: [String: Any] = [:]
    
    func object(forKey: String) -> Any? {
        dict[forKey]
    }
    
    func string(forKey: String) -> String? {
        object(forKey: forKey) as? String
    }
    
    func set(_ value: Any?, forKey: String) {
        dict[forKey] = value
    }
    
    
}
