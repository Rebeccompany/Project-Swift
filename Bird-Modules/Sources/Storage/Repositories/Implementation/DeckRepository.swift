//
//  DeckRepository.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import Combine
import Models

public final class DeckRepository: DeckRepositoryProtocol {
    
    private let deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>
    private let cardRepository: Repository<Card, CardEntity, CardModelEntityTransformer>
    private let cardSnapshotRepository: CardSnapshotRepository
    
    init(deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>,
         cardRepository: Repository<Card, CardEntity, CardModelEntityTransformer>,
         cardSnapshotRepository: CardSnapshotRepository) {
        self.deckRepository = deckRepository
        self.cardRepository = cardRepository
        self.cardSnapshotRepository = cardSnapshotRepository
    }
    
    public static let shared: DeckRepositoryProtocol = {
        DeckRepository(collectionId: nil)
    }()
    
    public convenience init(collectionId: UUID?) {
        let deckRepository = Repository(transformer: DeckModelEntityTransformer(collectionIds: collectionId), .shared)
        let cardRepository = Repository(transformer: CardModelEntityTransformer(), .shared)
        self.init(deckRepository: deckRepository, cardRepository: cardRepository, cardSnapshotRepository: CardSnapshotRepository(transformer: CardSnapshotTransformer()))
    }
    
    public func fetchDeckById(_ id: UUID) -> AnyPublisher<Deck, RepositoryError> {
        deckRepository.fetchById(id)
    }
    
    public func fetchDecksByIds(_ ids: [UUID]) -> AnyPublisher<[Deck], RepositoryError> {
        deckRepository.fetchMultipleById(ids)
    }
    
    public func deckListener() -> AnyPublisher<[Deck], RepositoryError> {
        do {
            let listener = try deckRepository.listener()
            return listener
        } catch {
            return Fail<[Deck], RepositoryError>(error: .errorOnListening).eraseToAnyPublisher()
        }
    }
    
    public func cardListener(forId deckId: UUID) -> AnyPublisher<[Card], RepositoryError> {
        do {
            let predicate = NSPredicate(format: "deck.id == %@", deckId as NSUUID)
            let listener = try cardRepository.listener(for: predicate)
            return listener
        } catch {
            return Fail<[Card], RepositoryError>(error: .errorOnListening).eraseToAnyPublisher()
        }
    }
    
    public func createDeck(_ deck: Deck, cards: [Card]) throws {
        let deckEntity = try deckRepository.create(deck)
        
        if !cards.isEmpty {
            try addCards(cards, to: deckEntity)
        }
    }
    
    private func addCards(_ cards: [Card], to deckEntity: DeckEntity) throws {
        let cardEntities = try cards.map(cardRepository.create(_:))
        
        cardEntities.forEach { card in
            deckEntity.addToCards(card)
        }
        
        try deckRepository.save()
    }
    
    public func deleteDeck(_ deck: Deck) throws {
        try deckRepository.delete(deck)
    }
    
    public func editDeck(_ deck: Deck) throws {
        let entity = try deckRepository.fetchEntityById(deck.id)
        
        entity.icon = deck.icon
        entity.name = deck.name
        entity.lastAccess = deck.datesLogs.lastAccess
        entity.lastEdit = deck.datesLogs.lastEdit
        entity.color = Int16(deck.color.rawValue)
        
        try deckRepository.save()
    }
    
    public func addCard(_ card: Card, to deck: Deck) throws {
        let cardEntity = try cardRepository.create(card)
        let deckEntity = try deckRepository.fetchEntityById(deck.id)
        
        deckEntity.addToCards(cardEntity)
        try deckRepository.save()
    }
    
    public func removeCard(_ card: Card, from deck: Deck) throws {
        let cardEntity = try cardRepository.fetchEntityById(card.id)
        let deckEntity = try deckRepository.fetchEntityById(deck.id)
        
        deckEntity.removeFromCards(cardEntity)
        
        try deckRepository.save()
    }
    
    public func fetchCardById(_ id: UUID) -> AnyPublisher<Card, RepositoryError> {
        cardRepository.fetchById(id)
    }
    
    public func fetchCardsByIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError> {
        cardRepository.fetchMultipleById(ids)
    }
    
    public func deleteCard(_ card: Card) throws {
        try cardRepository.delete(card)
    }
    
    public func editCard(_ card: Card) throws {
        let entity = try cardRepository.fetchEntityById(card.id)
        
        guard
            let frontData = NSAttributedString(card.front).rtfData(),
            let backData = NSAttributedString(card.back).rtfData()
        else {
            throw RepositoryError.couldNotEdit
        }
        
        entity.front = frontData
        entity.back = backData
        entity.color = Int16(card.color.rawValue)
        entity.wpStep = Int32(card.woodpeckerCardInfo.step)
        entity.wpEaseFactor = card.woodpeckerCardInfo.easeFactor
        entity.wpInterval = Int32(card.woodpeckerCardInfo.interval)
        entity.wpStreak = Int32(card.woodpeckerCardInfo.streak)
        entity.wpHasBeenPresented = card.woodpeckerCardInfo.hasBeenPresented
        entity.wpIsGraduated = card.woodpeckerCardInfo.isGraduated
        entity.lastAccess = card.datesLogs.lastAccess
        entity.lastEdit = card.datesLogs.lastEdit
        
        try cardRepository.save()
    }
    
    public func addHistory(_ snapshot: CardSnapshot, to card: Card) throws {
        let entity = try cardRepository.fetchEntityById(card.id)
        let snapshotEntity = cardSnapshotRepository.create(snapshot: snapshot)
        entity.addToHistory(snapshotEntity)
        try cardRepository.save()
    }
    
}

class CardSnapshotRepository {
    private let dataStorage: DataStorage
    private let transformer: CardSnapshotTransformer
    
    init(transformer: CardSnapshotTransformer, dataStorage: DataStorage = .shared) {
        self.transformer = transformer
        self.dataStorage = dataStorage
    }
    
    func create(snapshot: CardSnapshot) -> CardSnapshotEntity {
        return transformer.modelToEntity(snapshot, on: dataStorage.mainContext)
    }
}
