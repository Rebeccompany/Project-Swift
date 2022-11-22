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
    
    private var jwt: String?
    
    public init(session: EndpointResolverProtocol = URLSession.shared) {
        self.session = session
    }
    
    private func authenticate() -> some Publisher<String, URLError> {
        //swiftlint: disable trailing_closure
        session.dataTaskPublisher(for: .login)
            .print()
            .decodeWhenSuccess(to: String.self)
            .handleEvents(receiveOutput: { [weak self] jwt in self?.jwt = jwt })
            .receive(on: RunLoop.main)
    }
    
    public func getDeckFeed() -> AnyPublisher<[ExternalSection], URLError> {
        if let jwt {
            return deckFeedPublisher(token: jwt)
        } else {
            return authenticate()
                .flatMap {[weak self] token in
                    guard let self else { preconditionFailure("self is deinitialized") }
                    print(token)
                    return self.deckFeedPublisher(token: token)
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func deckFeedPublisher(token: String) -> AnyPublisher<[ExternalSection], URLError> {
        session.dataTaskPublisher(for: Endpoint.feed, authToken: token)
            .print()
            .decodeWhenSuccess(to: [ExternalSection].self)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public func getCardsFor(deckId: String, page: Int) -> AnyPublisher<[ExternalCard], URLError> {
        session.dataTaskPublisher(for: .cardsForDeck(id: deckId, page: page))
            .decodeWhenSuccess(to: [ExternalCard].self)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public func getDeck(by id: String) -> AnyPublisher<ExternalDeck, URLError> {
        session.dataTaskPublisher(for: .deck(id: id))
            .decodeWhenSuccess(to: ExternalDeck.self)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public func uploadNewDeck(_ deck: Deck, with cards: [Card]) -> AnyPublisher<String, URLError> {
        let dto = DeckAdapter.adapt(deck, with: cards)
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(dto) else {
            return Fail(outputType: String.self, failure: URLError(.cannotDecodeContentData)).eraseToAnyPublisher()
        }
        
        if let jwt {
            print("jwt", jwt)
            return session.dataTaskPublisher(for: .sendAnDeck(jsonData), authToken: jwt)
                .decodeWhenSuccess(to: String.self)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        } else {
            return authenticate()
                .flatMap {[weak self] token in
                    guard let self else { preconditionFailure("self is deinitialized") }
                    print(token)
                    print(try! String(data: jsonData, encoding: .utf8))
                    return self.session.dataTaskPublisher(for: .sendAnDeck(jsonData), authToken: token)
                        .print()
                        .decodeWhenSuccess(to: String.self)
                        .receive(on: RunLoop.main)
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
    }
    
    public func deleteDeck(_ deck: Deck) -> AnyPublisher<Void, URLError> {
        guard let storeId = deck.storeId else {
            return Fail(outputType: Void.self, failure: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: .deleteDeck(with: storeId))
            .verifyVoidSuccess()
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == URLSession.DataTaskPublisher.Output, Failure == URLSession.DataTaskPublisher.Failure {
    
    func verifySuccess() -> some Publisher<Data, Failure> {
        self
            .tryMap { data, response in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
    }
    
    func verifyVoidSuccess() -> some Publisher<Void, Failure> {
        self
            .tryMap { _, response in
                let range = 200...299
                guard let response = response as? HTTPURLResponse,
                      range.contains(response.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return Void()
            }
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
    }
    
    func decodeWhenSuccess<T: Decodable>(to type: T.Type) -> some Publisher<T, URLError> {
        self
            .verifySuccess()
            .decode(type: type, decoder: JSONDecoder())
            .mapToURLError()
    }
}

extension Publisher {
    func mapToURLError() -> some Publisher<Output, URLError> {
        self
            .mapError { error in
                if let error = error as? URLError {
                    return error
                } else {
                    return URLError(.cannotDecodeContentData)
                }
            }
    }
}
