//
//  SessionRepositoryProtocol.swift
//  
//
//  Created by Nathalia do Valle Papst on 03/10/22.
//

import Foundation
import Combine
import Models

public protocol SessionRepositoryProtocol {
    func currentSession(for deckId: UUID) -> Session?
    func setCurrentSession(session: Session) throws
    func editSession(_ session: Session) throws
}
