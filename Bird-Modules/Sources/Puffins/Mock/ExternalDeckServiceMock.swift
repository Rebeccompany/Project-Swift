//
//  ExternalDeckServiceMock.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation
import Models
import Combine

public final class ExternalDeckServiceMock: ExternalDeckServiceProtocol {
    
    public var shouldError = false
    public var error: URLError?
    public var expectedUploadString = ""
    
    public var feed: [ExternalSection] = [
        ExternalSection(title: getCategoryString(category: .stem), decks: [ExternalDeck(id: "1", name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem), ExternalDeck(id: "2", name: "Stem 2", description: "Stem Desc 2", icon: .abc, color: .darkBlue, category: .stem), ExternalDeck(id: "3", name: "Stem 3", description: "Stem Desc 3", icon: .atom, color: .gray, category: .stem)]),
        
        ExternalSection(title: getCategoryString(category: .humanities), decks: [ExternalDeck(id: "4", name: "Humanities 1", description: "Humanities Desc", icon: .gamecontroller, color: .green, category: .humanities)]),
        
        ExternalSection(title: getCategoryString(category: .languages), decks: [ExternalDeck(id: "5", name: "Languages 1", description: "Languages Desc", icon: .books, color: .lightBlue, category: .languages), ExternalDeck(id: "6", name: "Languages 2", description: "Languages Desc 2", icon: .cloudSun, color: .darkPurple, category: .languages), ExternalDeck(id: "7", name: "Languages 3", description: "Languages Desc 3", icon: .books, color: .pink, category: .languages), ExternalDeck(id: "8", name: "Languages 4", description: "Languages Desc 4", icon: .books, color: .beigeBrown, category: .languages)]),
        
        ExternalSection(title: getCategoryString(category: .arts), decks: [ExternalDeck(id: "9", name: "Arts 3", description: "Arts Desc 3", icon: .books, color: .orange, category: .arts), ExternalDeck(id: "10", name: "Arts 3", description: "Arts Desc 3", icon: .cpu, color: .lightBlue, category: .arts)]),
        
        ExternalSection(title: getCategoryString(category: .others), decks: [ExternalDeck(id: "11", name: "Others", description: "Others Desc", icon: .books, color: .darkPurple, category: .others)])
    ]
    
    public func deck(id: String) -> ExternalDeck {
        ExternalDeck(id: id, name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem)
    }
    
    public var cards: [ExternalCard] {
        [
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            ),
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            ),
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            ),
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            ),
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            ),
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            ),
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            ),
            ExternalCard(
                id: UUID().uuidString,
                front: "Lavender Hazer",
                back: "1",
                color: .darkBlue,
                deckId: "1"
            )
        ]
        
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
        return Just(cards).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func uploadNewDeck(_ deck: Deck, with cards: [Card]) -> AnyPublisher<String, URLError> {
        if shouldError {
            return Fail(outputType: String.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(expectedUploadString).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func deleteDeck(_ deck: Models.Deck) -> AnyPublisher<Void, URLError> {
        if shouldError {
            return Fail(outputType: Void.self, failure: error!).eraseToAnyPublisher()
        }
        return Just(Void()).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
    
    public func downloadDeck(with id: String) -> AnyPublisher<DeckDTO, URLError> {
        fatalError()
    }
}
