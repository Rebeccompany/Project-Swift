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
            .tryMap { (data, response) in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else { throw URLError(.badServerResponse) }
                
                return data
            }
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
            .tryMap { (data, response) in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else { throw URLError(.badServerResponse) }
                
                return data
            }
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
            .tryMap { (data, response) in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else { throw URLError(.badServerResponse) }
                
                return data
            }
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
        let dto = DeckAdapter.adapt(deck, with: cards)
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(dto) else {
            return Fail(outputType: String.self, failure: URLError(.cannotDecodeContentData)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: .sendAnDeck(jsonData))
            .tryMap { (data, response) in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else { throw URLError(.badServerResponse) }
                
                return data
            }
            .print()
            .decode(type: String.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public func deleteDeck(_ deck: Deck) -> AnyPublisher<Void, URLError> {
        guard let storeId = deck.storeId else {
            return Fail(outputType: Void.self, failure: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: .deleteDeck(with: storeId))
            .tryMap { (_, response) in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else {
                    print((response as? HTTPURLResponse)?.statusCode)
                    throw URLError(.badServerResponse)
                }
                print(response.statusCode)
                return Void()
            }
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
            .print()
            .eraseToAnyPublisher()
    }
}
