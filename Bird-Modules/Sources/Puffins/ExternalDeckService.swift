//
//  ExternalDeckService.swift
//
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation
import Combine
import Models

public final class ExternalDeckService: ExternalDeckServiceProtocol {
    
    //HANDLER DE URL
    private let session: EndpointResolverProtocol
    
    public static let shared: ExternalDeckService = .init()
    
    public init(session: EndpointResolverProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func getDeckFeed() -> AnyPublisher<[ExternalSection], URLError> {
        session.dataTaskPublisher(for: Endpoint.feed)
            .map(\.data)
            .decode(type: [ExternalSection].self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func getCardsFor(deckId: String, page: Int) -> AnyPublisher<[ExternalCard], URLError> {
        session.dataTaskPublisher(for: .cardsForDeck(id: deckId, page: page))
            .map(\.data)
            .decode(type: [ExternalCard].self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func getDeck(by id: String) -> AnyPublisher<ExternalDeck, URLError> {
        session.dataTaskPublisher(for: .deck(id: id))
            .map(\.data)
            .decode(type: ExternalDeck.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func uploadNewDeck(_ deck: Deck, with cards: [Card]) -> AnyPublisher<String, URLError> {
        fatalError()
    }
    
    public func deleteDeck(_ deck: Deck) -> AnyPublisher<Void, URLError> {
        fatalError()
    }
}
