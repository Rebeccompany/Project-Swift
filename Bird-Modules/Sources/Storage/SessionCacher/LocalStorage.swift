//
//  File.swift
//  
//
//  Created by Marcos Chevis on 05/09/22.
//

import Foundation
import Models


public protocol LocalStorageService {
    func object(forKey: String) -> Any?
    func string(forKey: String) -> String?
    
    func set(_ value: Any?, forKey: String)
}

extension UserDefaults: LocalStorageService {}


final public class SessionCacher {
    private let storage: LocalStorageService
    private let currentSessionKey: String = "com.birdmodules.storage.sessioncacher.session"
    
    public init(storage: LocalStorageService = UserDefaults.standard) {
        self.storage = storage
    }
    
    var currentSession: Session? {
        get {
            storage.object(forKey: currentSessionKey) as? Session
        }
        set {
            storage.set(newValue, forKey: currentSessionKey)
        }
    }
    
}
