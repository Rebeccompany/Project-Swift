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
            .decodeWhenSuccess(to: String.self)
            .handleEvents(receiveOutput: { [weak self] jwt in self?.jwt = jwt })
            .receive(on: RunLoop.main)
    }
    
    private func authenticatePublisher<Output>(_ publisher: @escaping (String) -> some Publisher<Output, URLError>) -> AnyPublisher<Output, URLError> {
        if let jwt {
            return publisher(jwt).eraseToAnyPublisher()
        } else {
            return authenticate()
                .flatMap { token in
                    publisher(token)
                }
                .mapToURLError()
                .eraseToAnyPublisher()
        }
    }
    
    public func getDeckFeed() -> AnyPublisher<[ExternalSection], URLError> {
        authenticatePublisher {[weak self] token in
            guard let self else { preconditionFailure("Self is denitialized") }
            return self.deckFeedPublisher(token: token)
        }
    }
    
    private func deckFeedPublisher(token: String) -> AnyPublisher<[ExternalSection], URLError> {
        session.dataTaskPublisher(for: Endpoint.feed, authToken: token)
            .decodeWhenSuccess(to: [ExternalSection].self)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    public func getCardsFor(deckId: String, page: Int) -> AnyPublisher<[ExternalCard], URLError> {
        authenticatePublisher { [weak self] token in
            guard let self else { preconditionFailure("Self is denitialized") }
            return self.session.dataTaskPublisher(for: .cardsForDeck(id: deckId, page: page), authToken: token)
                .decodeWhenSuccess(to: [ExternalCard].self)
                .receive(on: RunLoop.main)
        }
    }
    
    public func getDeck(by id: String) -> AnyPublisher<ExternalDeck, URLError> {
        authenticatePublisher {[weak self] token in
            guard let self else { preconditionFailure("Self is denitialized") }
            return self.session.dataTaskPublisher(for: .deck(id: id), authToken: token)
                .decodeWhenSuccess(to: ExternalDeck.self)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
    }
    
    public func uploadNewDeck(_ deck: Deck, with cards: [Card]) -> AnyPublisher<String, URLError> {
        let dto = DeckAdapter.adapt(deck, with: cards)
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(dto) else {
            return Fail(outputType: String.self, failure: URLError(.cannotDecodeContentData)).eraseToAnyPublisher()
        }
        
        return authenticatePublisher {[weak self] token in
            guard let self else { preconditionFailure("self is deinitialized") }
            return self.session.dataTaskPublisher(for: .sendAnDeck(jsonData), authToken: token)
                .decodeWhenSuccess(to: String.self)
                .receive(on: RunLoop.main)
        }
    }
    
    public func deleteDeck(_ deck: Deck) -> AnyPublisher<Void, URLError> {
        guard let storeId = deck.storeId else {
            return Fail(outputType: Void.self, failure: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return authenticatePublisher {[weak self] token in
            guard let self else { preconditionFailure("self is deinitialized") }
            return self.session.dataTaskPublisher(for: .deleteDeck(with: storeId), authToken: token)
                .verifyVoidSuccess()
                .eraseToAnyPublisher()
        }
    }
    
    public func downloadDeck(with id: String) -> AnyPublisher<DeckDTO, URLError> {
        authenticatePublisher {[weak self] token in
            guard let self else { preconditionFailure("self is deinitialized") }
            return self.session.dataTaskPublisher(for: .download(id: id), authToken: token)
                .decodeWhenSuccess(to: DeckDTO.self)
        }
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
