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


public final class SessionCacher {
    private let storage: LocalStorageService
    private let currentSessionKey: String = "com.birdmodules.storage.sessioncacher.session"
    
    public init(storage: LocalStorageService = UserDefaults.standard) {
        self.storage = storage
    }
    
    public func currentSession(for id: UUID) -> Session? {
        storage.object(forKey: sessionKey(for: id)) as? Session
    }
    
    public func setCurrentSession(session: Session) {
        storage.set(session, forKey: sessionKey(for: session.deckId))
    }
    
    private func sessionKey(for id: UUID) -> String {
        "\(currentSessionKey).\(id.uuidString)"
    }
    
}
