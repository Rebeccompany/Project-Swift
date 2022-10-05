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
    private let deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>
    private let cardsRepository: Repository<Card, CardEntity, CardModelEntityTransformer>
    
    init(sessionRepository: Repository<Session, SessionEntity, SessionModelEntityTransformer>, dateHandler: DateHandlerProtocol, deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>, cardsRepository: Repository<Card, CardEntity, CardModelEntityTransformer>) {
        self.sessionRepository = sessionRepository
        self.dateHandler = dateHandler
        self.deckRepository = deckRepository
        self.cardsRepository = cardsRepository
    }
    
    public static let shared: SessionRepositoryProtocol = {
        SessionRepository(sessionRepository: Repository(transformer: SessionModelEntityTransformer(), .shared), dateHandler: DateHandler(), deckRepository: Repository(transformer: DeckModelEntityTransformer(), .shared), cardsRepository: Repository(transformer: CardModelEntityTransformer(), .shared))
    }()
    
    public func currentSession(for deckId: UUID) -> Session? {
        let today = Calendar.current.startOfDay(for: dateHandler.today)
        let predicate = NSPredicate(format: "deck.id == %@ && date >= %@", deckId as NSUUID, today as NSDate)
        return try? sessionRepository.fetchByPredicate(predicate)
    }
    
    public func setCurrentSession(session: Session) throws {
        let entity = try sessionRepository.create(session)
        let deck = try deckRepository.fetchEntityById(session.deckId)
        let cards = try session.cardIds.map { id in
            try cardsRepository.fetchEntityById(id)
        }
        
        deck.addToSessions(entity)
        cards.forEach { card in
            entity.addToCards(card)
        }
        
        try sessionRepository.save()
    }
    
}
