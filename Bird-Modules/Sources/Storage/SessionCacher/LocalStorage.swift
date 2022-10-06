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
//    private let repository: SessionRepositoryProtocol
//
//    public init(repository: SessionRepositoryProtocol = SessionRepository.shared) {
//        self.repository = repository
//    }
//
//    public func currentSession(for id: UUID) -> Session? {
//
//        repository.currentSession(for: id)
//    }
//
//    public func setCurrentSession(session: Session) throws {
//        if let session = currentSession(for: session.deckId) {
//            try repository.editSession(session)
//        } else {
//            try repository.setCurrentSession(session: session)
//        }
//
//    }
    
}
