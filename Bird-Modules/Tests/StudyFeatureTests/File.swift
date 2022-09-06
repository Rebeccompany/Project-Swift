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
    
    var decks: [Deck] = [Deck(id: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2"),
                         Deck(id: "a498bc3c-85a3-4784-b560-a33a272a0a92"),
                         Deck(id: "4e56be0a-bc7c-4497-aec9-c30482e82496"),
                         Deck(id: "3947217b-2f55-4f16-ae59-10017d291579")
                         
    ]
    
    var cards: [Card] = [
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn),
        Card(id: "1f222564-ff0d-4f2d-9598-1a0542899974", deckId: "c3046ed9-83fb-4c81-a83c-b11ae4863bd2", state: .learn)
    ]
    
    func fetchDeckById(_ id: UUID) -> AnyPublisher<Deck, RepositoryError> {
        
    }
    
    func fetchDecksByIds(_ ids: [UUID]) -> AnyPublisher<[Deck], RepositoryError> {
        
    }
    
    func deckListener() -> AnyPublisher<[Deck], RepositoryError> {
        
    }
    
    func createDeck(_ deck: Deck, cards: [Card]) throws {
        
    }
    
    func deleteDeck(_ deck: Deck) throws {
        
    }
    
    func editDeck(_ deck: Deck) throws {
        
    }
    
    func addCard(_ card: Card, to deck: Deck) throws {
        
    }
    
    func removeCard(_ card: Card, from deck: Deck) throws {
        
    }
    
    func fetchCardById(_ id: UUID) -> AnyPublisher<Card, RepositoryError> {
        
    }
    
    func fetchCardsByIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError> {
        
    }
    
    func deleteCard(_ card: Card) throws {
        
    }
    
    func editCard(_ card: Card) throws {
        
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
        self.init(id: UUID(uuidString: id)!,
                  front: "",
                  back: "",
                  color: .red,
                  datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                      lastEdit: Date(timeIntervalSince1970: 0),
                                      createdAt: Date(timeIntervalSince1970: 0)),
                  deckID: UUID(uuidString: deckId)!,
                  woodpeckerCardInfo: WoodpeckerCardInfo(state: state),
                  history: [])
    }
}

extension Deck {
    init(id: String) {
        self.init(id: UUID(uuidString: id)!,
                  name: "Progamação Swift",
                  icon: "chevron.down",
                  color: .red,
                  datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                      lastEdit: Date(timeIntervalSince1970: 0),
                                      createdAt: Date(timeIntervalSince1970: 0)),
                  collectionsIds: [],
                  cardsIds: [],
                  spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                maxReviewingCards: 200))
    }
}
