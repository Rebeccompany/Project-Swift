//
//  SessionRepository.swift
//  
//
//  Created by Nathalia do Valle Papst on 03/10/22.
//

import Foundation
import Combine
import Models
import Utils

public final class SessionRepository: SessionRepositoryProtocol {
    
    private let sessionRepository: Repository<Session, SessionEntity, SessionModelEntityTransformer>
    private let dateHandler: DateHandlerProtocol
    
    init(sessionRepository: Repository<Session, SessionEntity, SessionModelEntityTransformer>, dateHandler: DateHandlerProtocol) {
        self.sessionRepository = sessionRepository
        self.dateHandler = dateHandler
    }
    
    public static let shared: SessionRepositoryProtocol = {
        SessionRepository(sessionRepository: Repository(transformer: SessionModelEntityTransformer(), .shared), dateHandler: DateHandler())
    }()
    
    public func currentSession(for deckId: UUID) -> Session? {
        let today = Calendar.current.startOfDay(for: dateHandler.today)
        let predicate = NSPredicate(format: "deck.id == %@ && date >= %@", deckId as NSUUID, today as NSDate)
        return try? sessionRepository.fetchByPredicate(predicate)
    }
    
    public func setCurrentSession(session: Session) throws {
    
    }
    
}
