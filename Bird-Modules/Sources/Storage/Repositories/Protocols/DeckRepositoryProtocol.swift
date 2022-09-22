//
//  DeckRepositoryProtocol.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/08/22.
//

import Foundation
import Combine
import Models

public protocol DeckRepositoryProtocol: AnyObject {
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
    func cardListener(forId deckId: UUID) -> AnyPublisher<[Card], RepositoryError>
    
    func fetchCardById(_ id: UUID) -> AnyPublisher<Card, RepositoryError>
    func fetchCardsByIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError>
    
    func deleteCard(_ card: Card) throws
    func editCard(_ card: Card) throws
    
}
