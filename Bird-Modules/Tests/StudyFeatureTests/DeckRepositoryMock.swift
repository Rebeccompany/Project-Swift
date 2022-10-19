//
//  File.swift
//  
//
//  Created by Marcos Chevis on 06/09/22.
//

import Foundation
import Storage
import Models
import Combine

class DeckRepositoryMock: DeckRepositoryProtocol {
    
    var deckWithCardsId: UUID = UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2")!
    
    lazy var decks: [Deck] = [Deck(id: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2",
                                   cardsIds: cards.filter { $0.deckID == UUID(uuidString: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2") }.map(\.id)),
                              Deck(id: "a498bc3c-85a3-4784-b560-a33a272a0a92",
                                   cardsIds: cards.filter { $0.deckID == UUID(uuidString: "a498bc3c-85a3-4784-b560-a33a272a0a92") }.map(\.id)),
                              Deck(id: "4e56be0a-bc7c-4497-aec9-c30482e82496",
                                   cardsIds: Array(cards.filter { $0.deckID == UUID(uuidString: "4e56be0a-bc7c-4497-aec9-c30482e82496") }.map(\.id)),
                                   spacedConfig: SpacedRepetitionConfig(maxLearningCards: 20, maxReviewingCards: 3)),
                              Deck(id: "3947217b-2f55-4f16-ae59-10017d291579",
                                   cardsIds: cards.filter { $0.deckID == UUID(uuidString: "3947217b-2f55-4f16-ae59-10017d291579") }.map(\.id))
                              
    ]
    
    lazy var subject: CurrentValueSubject<[Deck], RepositoryError> = .init(decks)
    lazy var cardSubject: CurrentValueSubject<[Card], RepositoryError> = .init(cards)
    
    var cards: [Card] = [
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn), //0
        Card(id: "66605408-4cd4-4ded-b23d-91db9249a946", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn), //1
        Card(id: "4f298230-4286-4a83-9f1c-53fd60533ed8", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn), //2
        Card(id: "9b06af85-e4e8-442d-be7a-40450cfd310c", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn), //3
        Card(id: "855eb618-602e-449d-83fc-5de6b8a36454", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn), //4
        Card(id: "5285798a-4107-48b3-8994-e706699a3445", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn), //5
        Card(id: "407e7694-316e-4903-9c94-b3ec0e9ab0e8", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn), //6
        Card(id: "09ae6b07-b988-442f-a059-9ea76d5c9055", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .review), //7
        Card(id: "d3b5ba9a-7805-480e-ad47-43b842f0472f", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .review), //8
        Card(id: "d9d3d4ec-9854-4e73-864b-1e68355a6973", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .review), //9
        Card(id: "c24affd7-376d-4614-9ad6-8a83a0f60da5", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .review), //10
        Card(id: "d2c951fb-36f5-49dc-84f0-353a3b3a2875", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .review), //11
        
        Card(id: "021ff721-cf68-4cf4-898c-14b9eb6bb0a5", deckId: "4e56be0a-bc7c-4497-aec9-c30482e82496", state: .review), //12
        Card(id: "aa03ffb2-ac98-4656-9400-b5b22b2058d5", deckId: "4e56be0a-bc7c-4497-aec9-c30482e82496", state: .review), //13
        Card(id: "57d08e28-ae11-43ce-a849-6210cab6e3f0", deckId: "4e56be0a-bc7c-4497-aec9-c30482e82496", state: .review), //14
        Card(id: "ad631ff8-b851-4870-938a-b3aea335577c", deckId: "4e56be0a-bc7c-4497-aec9-c30482e82496", state: .review), //15
        
        Card(id: "cd3cc305-e80e-4c84-b1e5-e27fda8a9cfe", deckId: "a498bc3c-85a3-4784-b560-a33a272a0a92", state: .learn), //16
        
        Card(id: "5896cc41-ce48-44af-80f0-844dd24bca0b", deckId: "3947217b-2f55-4f16-ae59-10017d291579", state: .review), //17
        Card(id: "df6dcb79-28a4-4aae-8c6e-7656e4e79d2e", deckId: "3947217b-2f55-4f16-ae59-10017d291579", state: .review) //18
        
    ]
    
    func fetchDeckById(_ id: UUID) -> AnyPublisher<Deck, RepositoryError> {
        if let deck = decks.first(where: { deck in deck.id == id }) {
            return Just(deck).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } else {
            return Fail<Deck,RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
        }
    }
    
    func fetchDecksByIds(_ ids: [UUID]) -> AnyPublisher<[Deck], RepositoryError> {
        let decks = decks.filter { deck in ids.contains(deck.id) }
        return Just(decks).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        
    }
    
    func deckListener() -> AnyPublisher<[Deck], RepositoryError> {
        subject.eraseToAnyPublisher()
    }
    
    func cardListener(forId deckId: UUID) -> AnyPublisher<[Card], RepositoryError> {
        cardSubject.map { $0.filter { card in card.deckID == deckId } }.eraseToAnyPublisher()
    }
    
    func createDeck(_ deck: Deck, cards: [Card]) throws {
        var deck = deck
        deck.cardsIds = cards.map(\.id)
        decks.append(deck)
        self.cards += cards
        
    }
    
    func deleteDeck(_ deck: Deck) throws {
        decks.removeAll { d in
            d.id == deck.id
        }
    }
    
    func editDeck(_ deck: Deck) throws {
        if let i = decks.firstIndex(where: { d in d.id == deck.id }) {
            decks[i] = deck
        } else {
            throw RepositoryError.couldNotEdit
        }
        
    }
    
    func addCard(_ card: Card, to deck: Deck) throws {
        if let i = decks.firstIndex(where: { d in d.id == deck.id }) {
            decks[i] = deck
        } else {
            throw RepositoryError.couldNotEdit
        }
    }
    
    func removeCard(_ card: Card, from deck: Deck) throws {
        cards.removeAll { $0.id == card.id }
        decks = decks.map { d in
            var d = d
            d.cardsIds = d.cardsIds.filter { id in id != card.id }
            return d
        }
    }
    
    func fetchCardById(_ id: UUID) -> AnyPublisher<Card, RepositoryError> {
        if let card = cards.first(where: { card in card.id == id }) {
            return Just(card).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } else {
            return Fail<Card,RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
        }
    }
    
    func fetchCardsByIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError> {
        let cards = cards.filter { card in ids.contains(card.id) }
        return Just(cards).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
    }
    
    func deleteCard(_ card: Card) throws {
        cards.removeAll { $0.id == card.id }
        decks = decks.map { d in
            var d = d
            d.cardsIds = d.cardsIds.filter { id in id != card.id }
            return d
        }
    }
    
    func editCard(_ card: Card) throws {
        if let i = cards.firstIndex(where: { d in d.id == card.id }) {
            cards[i] = card
        } else {
            throw RepositoryError.couldNotEdit
        }
    }
    
    public func createSession(_ session: Session, for deck: Deck) throws {
        
        guard let index = decks.firstIndex(where:  {deck.id == $0.id}) else {
            throw NSError()
        }
        
        decks[index].session = session
    }
    
    public func editSession(_ session: Session) throws {
        
        guard let index = decks.firstIndex(where: { deck in
            deck.session?.id == session.id
        }) else { throw NSError() }
        
        decks[index].session = session
    }
    
    public func deleteSession(_ session: Session, for deck: Deck) throws {
        
        guard let index = decks.firstIndex(of: deck) else {
            throw NSError()
        }
        
        decks[index].session = nil
    }
    
    public func addCardsToSession(_ session: Session, cards: [Card]) throws {
        
        var session = session
        
        session.cardIds.append(contentsOf: cards.map(\.id))
    }
    
    public func removeCardsFromSession(_ session: Session, cards: [Card]) throws {

        var session = session
        
        session.cardIds.removeAll { id in
            cards.map(\.id).contains(id)
        }
    }

    func addHistory(_ snapshot: CardSnapshot, to card: Card) throws {
        guard let index = cards.firstIndex(of: card) else { throw NSError() }
        var card = card
        card.history.append(snapshot)
        
        cards[index] = card
    }
    
    
}

enum WoodpeckerState {
    case review, learn
}

extension WoodpeckerCardInfo {
    init(state: WoodpeckerState) {
        let isg: Bool
        let interval: Int
        switch state {
        case .review:
            isg = true
            interval = 1
            
        case .learn:
            isg = false
            interval = 0
        }
        self.init(step: 0, isGraduated: isg, easeFactor: 2.5, streak: 0, interval: interval, hasBeenPresented: isg)
    }
}

extension Card {
    init(id: String, deckId: String, state: WoodpeckerState) {
        let h: [CardSnapshot]
        switch state {
        case .review:
            h = [CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(state: .learn), userGrade: .correct, timeSpend: 20, date: Date(timeIntervalSince1970: -8400))]
        case .learn:
            h = []
        }
        self.init(id: UUID(uuidString: id)!,
                  front: "",
                  back: "",
                  color: .red,
                  datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                      lastEdit: Date(timeIntervalSince1970: 0),
                                      createdAt: Date(timeIntervalSince1970: 0)),
                  deckID: UUID(uuidString: deckId)!,
                  woodpeckerCardInfo: WoodpeckerCardInfo(state: state),
                  history: h)
    }
}

extension Deck {
    init(id: String, cardsIds: [UUID] = [], spacedConfig: SpacedRepetitionConfig = .init(maxLearningCards: 20,
                                                                                         maxReviewingCards: 200)) {
        self.init(id: UUID(uuidString: id)!,
                  name: "Progamação Swift",
                  icon: "chevron.down",
                  color: .red,
                  datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                      lastEdit: Date(timeIntervalSince1970: 0),
                                      createdAt: Date(timeIntervalSince1970: 0)),
                  collectionId: nil,
                  cardsIds: cardsIds,
                  spacedRepetitionConfig: spacedConfig)
    }
}
