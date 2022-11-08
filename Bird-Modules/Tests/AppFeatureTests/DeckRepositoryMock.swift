////
////  DeckRepositoryMock.swift
////  
////
////  Created by Caroline Taus on 01/11/22.
////
//
//import Foundation
//import Storage
//import Combine
//import Models
//
//struct Wrapper {
//    var deck: Deck
//    var cards: [Card]
//}
//
//final class DeckRepositoryMock: DeckRepositoryProtocol {
//    
//    var data: [UUID: Wrapper]
//    var shouldThrowError: Bool
//    
//    var deckSubject: CurrentValueSubject<[Deck], RepositoryError>
//    var cardSubject: CurrentValueSubject<[Card], RepositoryError>
//    
//    init(data: [UUID: Wrapper] = [:], shouldThrowError: Bool = false) {
//        self.data = data
//        self.shouldThrowError = shouldThrowError
//        
//        deckSubject = .init(data.values.map(\.deck))
//        cardSubject = .init([])
//    }
//    
//    public func fetchDeckById(_ id: UUID) -> AnyPublisher<Deck, RepositoryError> {
//        if let deck = data[id]?.deck {
//            return Just(deck).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
//        } else {
//            return Fail<Deck, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
//        }
//    }
//    
//    
//    public func fetchDecksByIds(_ ids: [UUID]) -> AnyPublisher<[Deck], RepositoryError> {
//        let decks = data.filter { wrap in ids.contains(wrap.key) }.map(\.value.deck)
//        return Just(decks).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
//        
//    }
//    
//    public func deckListener() -> AnyPublisher<[Deck], RepositoryError> {
//        deckSubject.eraseToAnyPublisher()
//    }
//    
//    public func cardListener(forId deckId: UUID) -> AnyPublisher<[Card], RepositoryError> {
//        cardSubject.value = data[deckId]?.cards ?? []
//        return cardSubject.eraseToAnyPublisher()
//    }
//    
//    public func createDeck(_ deck: Deck, cards: [Card]) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotCreate
//        }
//        
//        var deck = deck
//        deck.cardsIds = cards.map(\.id)
//        
//        let newCards = cards.map { card in
//            var n = card
//            n.deckID = deck.id
//            
//            return n
//        }
//        
//        data[deck.id] = Wrapper(deck: deck, cards: cards)
//        
//        
//        deckSubject.send(data.values.map(\.deck))
//        cardSubject.send(cards)
//    }
//    
//    public func deleteDeck(_ deck: Deck) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotDelete
//        }
//        
//        data.remove(at: data.keys.firstIndex(where: { id in
//            id == deck.id
//        })!)
//        
//        deckSubject.send(data.values.map(\.deck))
//        cardSubject.send([])
//    }
//    
//    public func editDeck(_ deck: Deck) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotEdit
//        }
//        guard data[deck.id] != nil else { throw RepositoryError.couldNotEdit }
//        data[deck.id]?.deck = deck
//        deckSubject.send(data.values.map(\.deck))
//        cardSubject.send(data[deck.id]!.cards)
//    }
//    
//    public func addCard(_ card: Card, to deck: Deck) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotCreate
//        }
//        guard data[deck.id] != nil else { throw RepositoryError.couldNotCreate }
//        
//        data[deck.id]?.cards.append(card)
//        data[deck.id]?.deck.cardsIds.append(card.id)
//        
//        deckSubject.send(data.values.map(\.deck))
//        cardSubject.send(data[deck.id]!.cards)
//    }
//    
//    public func removeCard(_ card: Card, from deck: Deck) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotDelete
//        }
//        
//        data[deck.id]?.deck.cardsIds.removeAll(where: { id in
//            id == card.id
//        })
//        data[deck.id]?.cards.removeAll(where: { c in
//            c.id == card.id
//        })
//        
//        deckSubject.send(data.values.map(\.deck))
//        cardSubject.send(data[deck.id]!.cards)
//    }
//    
//    
//    public func fetchCardById(_ id: UUID) -> AnyPublisher<Card, RepositoryError> {
//        if let card = data.values.flatMap(\.cards).first(where: { $0.id == id }) {
//            return Just(card).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
//        } else {
//            return Fail<Card, RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
//        }
//    }
//    
//    public func fetchCardsByIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError> {
//        let cards = data.values.flatMap(\.cards).filter { ids.contains($0.id) }
//        return Just(cards).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
//    }
//    
//    public func deleteCard(_ card: Card) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotDelete
//        }
//        let index = card.deckID
//        data[index]?.cards.removeAll(where: { card == $0 })
//        
//        
//        data[index]?.deck.cardsIds.removeAll(where:{ card.id == $0})
//        
//        deckSubject.send(data.values.map(\.deck))
//        cardSubject.send(data[index]!.cards)
//    }
//    
//    public func editCard(_ card: Card) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotEdit
//        }
//        let index = card.deckID
//        if let i = data[index]?.cards.firstIndex(where: { card.id == $0.id }) {
//            data[index]?.cards[i] = card
//        } else {
//            throw RepositoryError.couldNotEdit
//        }
//        
//        cardSubject.send(data[index]!.cards)
//    }
//    
//    public func createSession(_ session: Session, for deck: Deck) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotCreate
//        }
//        if data[deck.id] == nil {
//            throw RepositoryError.notFound
//        }
//        
//        data[deck.id]?.deck.session = session
//        deckSubject.send(data.values.map(\.deck))
//    }
//    
//    public func editSession(_ session: Session) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotEdit
//        }
//        guard let index = data.values.map(\.deck).first(where: { deck in
//            deck.session?.id == session.id
//        })?.id else {
//            throw RepositoryError.notFound
//        }
//        
//        if data[index] == nil {
//            throw RepositoryError.notFound
//        }
//        data[index]?.deck.session = session
//        deckSubject.send(data.values.map(\.deck))
//    }
//    
//    
//    public func deleteSession(_ session: Session, for deck: Deck) throws {
//        if shouldThrowError {
//            throw RepositoryError.couldNotDelete
//        }
//        if data[deck.id] == nil {
//            throw RepositoryError.notFound
//        }
//        data[deck.id]?.deck.session = nil
//        deckSubject.send(data.values.map(\.deck))
//    }
//    
//    
//    public func addCardsToSession(_ session: Session, cards: [Card]) throws {
//        if shouldThrowError {
//            throw RepositoryError.internalError
//        }
//        
//        var session = session
//        
//        session.cardIds.append(contentsOf: cards.map(\.id))
//        
//        guard let index = data.values.map(\.deck).first(where: { deck in
//            deck.session?.id == session.id
//        })?.id else {
//            throw RepositoryError.notFound
//        }
//        
//        if data[index] == nil {
//            throw RepositoryError.notFound
//        }
//        
//        guard let oldCardsIds = data[index]?.deck.session?.cardIds else { throw NSError() }
//        
//        let newCardsIds = cards.filter { card in
//            !oldCardsIds.contains(card.id)
//        }.map(\.id)
//        
//        data[index]?.deck.session?.cardIds.append(contentsOf: newCardsIds)
//        
//        deckSubject.send(data.values.map(\.deck))
//    }
//    
//    public func removeCardsFromSession(_ session: Session, cards: [Card]) throws {
//        if shouldThrowError {
//            throw RepositoryError.internalError
//        }
//        
//        
//        guard let index = data.values.map(\.deck).first(where: { deck in
//            deck.session?.id == session.id
//        })?.id else {
//            throw RepositoryError.notFound
//        }
//        
//        if data[index] == nil {
//            throw RepositoryError.notFound
//        }
//        
//        let ids = cards.map { $0.id }
//        data[index]?.deck.session?.cardIds.removeAll { id in
//            ids.contains(id)
//        }
//        
//        deckSubject.send(data.values.map(\.deck))
//    }
//    
//    public func addHistory(_ snapshot: CardSnapshot, to card: Card) throws {
//        
//        let deckIndex = card.deckID
//        guard let cardIndex = data[deckIndex]?.cards.firstIndex(where: { $0.id == card.id }) else { throw NSError() }
//        data[deckIndex]?.cards[cardIndex].history.append(snapshot)
//        
//        cardSubject.send(data[deckIndex]!.cards)
//    }
//    
//}
