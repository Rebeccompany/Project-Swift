//
//  ExternalDeckServiceMock.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation
import Models
import Utils
import Combine

public final class ExternalDeckServiceMock: ExternalDeckServiceProtocol {
    
    public var shouldError = false
    public var error: URLError?
    public var expectedUploadString = ""
    
    public var feed: [ExternalSection] = [
        ExternalSection(title: getCategoryString(category: .stem), decks: [
            ExternalDeck(id: "1", name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem, ownerId: "id", ownerName: "name", cardCount: 3),
            ExternalDeck(id: "2", name: "Stem 2", description: "Stem Desc 2", icon: .abc, color: .darkBlue, category: .stem, ownerId: "id", ownerName: "name", cardCount: 3),
            ExternalDeck(id: "3", name: "Stem 3", description: "Stem Desc 3", icon: .atom, color: .gray, category: .stem, ownerId: "id", ownerName: "name", cardCount: 3)
        ]),
        
        ExternalSection(title: getCategoryString(category: .humanities), decks: [
            ExternalDeck(id: "4", name: "Humanities 1", description: "Humanities Desc", icon: .gamecontroller, color: .green, category: .humanities, ownerId: "id", ownerName: "name", cardCount: 3)
        ]),
        
        ExternalSection(title: getCategoryString(category: .languages), decks: [
            ExternalDeck(id: "5", name: "Languages 1", description: "Languages Desc", icon: .books, color: .lightBlue, category: .languages, ownerId: "id", ownerName: "name", cardCount: 3),
            ExternalDeck(id: "6", name: "Languages 2", description: "Languages Desc 2", icon: .cloudSun, color: .darkPurple, category: .languages, ownerId: "id", ownerName: "name", cardCount: 3),
            ExternalDeck(id: "7", name: "Languages 3", description: "Languages Desc 3", icon: .books, color: .pink, category: .languages, ownerId: "id", ownerName: "name", cardCount: 3),
            ExternalDeck(id: "8", name: "Languages 4", description: "Languages Desc 4", icon: .books, color: .beigeBrown, category: .languages, ownerId: "id", ownerName: "name", cardCount: 3)
        ]),
        
        ExternalSection(title: getCategoryString(category: .arts), decks: [
            ExternalDeck(id: "9", name: "Arts 3", description: "Arts Desc 3", icon: .books, color: .orange, category: .arts, ownerId: "id", ownerName: "name", cardCount: 3),
            ExternalDeck(id: "10", name: "Arts 3", description: "Arts Desc 3", icon: .cpu, color: .lightBlue, category: .arts, ownerId: "id", ownerName: "name", cardCount: 3)
        ]),
        
        ExternalSection(title: getCategoryString(category: .others), decks: [
            ExternalDeck(id: "11", name: "Others", description: "Others Desc", icon: .books, color: .darkPurple, category: .others, ownerId: "id", ownerName: "name", cardCount: 3)
        ])
    ]
    
    public func deck(id: String) -> ExternalDeck {
        ExternalDeck(id: id, name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem, ownerId: "id", ownerName: "name", cardCount: 3)
    }
    
    public var cards: [ExternalCard] {
        Array(1...10).map { ExternalCard(
            id: "\($0)",
            front: "Lavender Hazer",
            back: "1",
            color: .darkBlue,
            deckId: "1"
            )
        }
        
    }
    
    public func deckDTO(id: String) -> DeckDTO {
        DeckDTO(
            id: id,
            name: "DTO",
            description: "description",
            icon: .leaf,
            color: .darkPurple,
            category: .languages,
            ownerId: "owner",
            ownerName: "ownerName",
            cards: Array(1...10).map { _ in
                CardDTO(
                    front: String(data: NSAttributedString(string: "front").rtfData()!, encoding: .utf8)!,
                    back: String(data: NSAttributedString(string: "back").rtfData()!, encoding: .utf8)!,
                    color: .darkBlue)
            }
        )
    }
    
    public init() {
        
    }
    
    public func getDeckFeed() -> AnyPublisher<[ExternalSection], URLError> {
        if shouldError {
            return Fail<[ExternalSection], URLError>(error: URLError(.cannotDecodeContentData)).eraseToAnyPublisher()
        } else {
            return Just(feed).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }
        
    }
    
    public func getDeck(by id: String) -> AnyPublisher<ExternalDeck, URLError> {
        if shouldError {
            return Fail(outputType: ExternalDeck.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(deck(id: id))
            .setFailureType(to: URLError.self)
            .eraseToAnyPublisher()
    }
    
    public func getCardsFor(deckId: String, page: Int) -> AnyPublisher<[ExternalCard], URLError> {
        if shouldError {
            return Fail(outputType: [ExternalCard].self, failure: error!).eraseToAnyPublisher()
        }
        
        if page == 0 {
            return Just(cards).setFailureType(to: URLError.self).eraseToAnyPublisher()
        } else {
            return Just([]).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }
    }
    
    public func uploadNewDeck(_ deck: Deck, with cards: [Card], owner: User) -> AnyPublisher<String, URLError> {
        if shouldError {
            return Fail(outputType: String.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(expectedUploadString).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func deleteDeck(_ deck: Deck) -> AnyPublisher<Void, URLError> {
        if shouldError {
            return Fail(outputType: Void.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(Void()).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func downloadDeck(with id: String) -> AnyPublisher<DeckDTO, URLError> {
        if shouldError {
            return Fail(outputType: DeckDTO.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(deckDTO(id: id)).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public  func updateADeck(_ deck: Deck, with cards: [Card], owner: User) -> AnyPublisher<Void, URLError> {
        if shouldError {
            return Fail(outputType: Void.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(Void()).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func deleteAllDeckFromUser(id: String) -> AnyPublisher<Void, URLError> {
        if shouldError {
            return Fail(outputType: Void.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(Void()).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func searchDecks(type: String, value: String, page: Int) -> AnyPublisher<[ExternalDeck], URLError> {
        if shouldError {
            return Fail(outputType: [ExternalDeck].self, failure: error!).eraseToAnyPublisher()
        } else if page > 3 {
            return Just<[ExternalDeck]>([]).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }
        let decks = Array(1...30).map { i in deck(id: "\(i + (page * 30))") }
        return Just(decks).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func decksByCategory(category: DeckCategory, page: Int) -> AnyPublisher<[Models.ExternalDeck], URLError> {
        if shouldError {
            return Fail(outputType: [ExternalDeck].self, failure: error!).eraseToAnyPublisher()
        } else if page > 3 {
            return Just<[ExternalDeck]>([]).setFailureType(to: URLError.self).eraseToAnyPublisher()
        }
        let decks = Array(1...30).map { i in deck(id: "\(i + (page * 30))") }.map {
            ExternalDeck(id: $0.id, name: $0.name, description: $0.description, icon: $0.icon, color: $0.color, category: category, ownerId: $0.ownerId, ownerName: $0.ownerName, cardCount: $0.cardCount)
        }
        return Just(decks).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
}
