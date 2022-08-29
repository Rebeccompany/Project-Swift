//
//  DeckRepository.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import Combine
import Models

//MARK: - Protocol
public protocol DeckRepositoryProtocol {
    // Deck
    func fetchDeckById(_ id: UUID) -> AnyPublisher<Deck, RepositoryError>
    func fetchDecksByIds(_ ids: [UUID]) -> AnyPublisher<[Deck], RepositoryError>
    func deckListener() -> AnyPublisher<[Deck], RepositoryError>
    
    func createDeck(_ deck: Deck, cards: [Card]) throws
    func deleteDeck(_ deck: Deck) throws
    func editDeck(_ deck: Deck) throws
    
    func addCard(_ card: Card, to deck: Deck) throws
    func removeCard(_ card: Card, from deck: Deck) throws
    
    // Card
    func fetchCardById(_ id: UUID) -> AnyPublisher<Card, RepositoryError>
    func fetchCardsByIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError>
    
    func createCard(_ card: Card) throws
    func deleteCard(_ card: Card) throws
    func editCard(_ card: Card) throws
    
}

//MARK: - Implementation

public final class DeckRepository: DeckRepositoryProtocol {
    
    private let deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>
    private let cardRepository: Repository<Card, CardEntity, CardModelEntityTransformer>
    
    init(deckRepository: Repository<Deck, DeckEntity, DeckModelEntityTransformer>,
         cardRepository: Repository<Card, CardEntity, CardModelEntityTransformer>) {
        self.deckRepository = deckRepository
        self.cardRepository = cardRepository
    }
    
    convenience public init(collectionId: UUID?) {
        let deckRepository = Repository(transformer: DeckModelEntityTransformer(collectionIds: collectionId), .shared)
        let cardRepository = Repository(transformer: CardModelEntityTransformer(), .shared)
        self.init(deckRepository: deckRepository, cardRepository: cardRepository)
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
    
    public func createDeck(_ deck: Deck, cards: [Card]) throws {
        let cardEntities = try cards.map(cardRepository.create(_:))
        
        let deckEntity = try deckRepository.create(deck)
        
        cardEntities.forEach { card in
            deckEntity.addToCards(card)
        }
        
        //try deckRepository.save()
    }
    
    public func deleteDeck(_ deck: Deck) throws {
        try deckRepository.delete(deck)
    }
    
    public func editDeck(_ deck: Deck) throws {
        fatalError()
    }
    
    public func addCard(_ card: Card, to deck: Deck) throws {
        
    }
    
    public func removeCard(_ card: Card, from deck: Deck) throws {
        
    }
    
    public func fetchCardById(_ id: UUID) -> AnyPublisher<Card, RepositoryError> {
        fatalError()
    }
    
    public func fetchCardsByIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError> {
        fatalError()
    }
    
    public func createCard(_ card: Card) throws {
        fatalError()
    }
    
    public func deleteCard(_ card: Card) throws {
        fatalError()
    }
    
    public func editCard(_ card: Card) throws {
        fatalError()
    }
    
}
