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
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let currentSessionKey: String = "com.birdmodules.storage.sessioncacher.session"
    
    public init(storage: LocalStorageService = UserDefaults.standard) {
        self.storage = storage
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }
    
    public func currentSession(for id: UUID) -> Session? {
        guard
            let sessionData = storage.object(forKey: sessionKey(for: id)) as? Data,
            let session = try? decoder.decode(Session.self, from: sessionData)
        else {
            return nil
        }
        
        return session
    }
    
    public func setCurrentSession(session: Session) {
        let data = try? encoder.encode(session)
        storage.set(data, forKey: sessionKey(for: session.deckId))
    }
    
    private func sessionKey(for id: UUID) -> String {
        "\(currentSessionKey).\(id.uuidString)"
    }
    
}
