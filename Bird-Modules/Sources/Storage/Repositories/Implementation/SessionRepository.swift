//
//  SessionRepository.swift
//  
//
//  Created by Nathalia do Valle Papst on 03/10/22.
//

import Foundation
import Combine
import Models

public final class SessionRepository: SessionRepositoryProtocol {
    
    private let sessionRepository: Repository<Session, SessionEntity, SessionModelEntityTransformer>
    
    init(sessionRepository: Repository<Session, SessionEntity, SessionModelEntityTransformer>) {
        self.sessionRepository = sessionRepository
    }
    
    public func object(forKey: String) -> Any? {
        <#code#>
    }
    
    public func string(forKey: String) -> String? {
        <#code#>
    }
    
    public func set(_ value: Any?, forKey: String) {
        <#code#>
    }
    
    
}
