//
//  ExternalDeckService.swift
//
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation
import Combine
import Models
import Utils

struct Jwt {
    let key: String
    let date: Date
}

public final class ExternalDeckService: ExternalDeckServiceProtocol {
    
    //HANDLER DE URL
    private let session: EndpointResolverProtocol
    
    public static let shared: ExternalDeckService = .init()
    
    private var jwt: Jwt?
    
    private let dateHandler: DateHandlerProtocol
    
    public init(session: EndpointResolverProtocol = URLSession.shared,
                dateHandler: DateHandlerProtocol = DateHandler()) {
        self.session = session
        self.dateHandler = dateHandler
    }
    
    private func authenticate() -> some Publisher<String, URLError> {
        //swiftlint: disable trailing_closure
        session.dataTaskPublisher(for: .login)
            .decodeWhenSuccess(to: String.self)
            .handleEvents(receiveOutput: { [weak self] jwt in
                self?.jwt = Jwt(key: jwt, date: self?.dateHandler.today ?? Date.now)
            })
            .receive(on: RunLoop.main)
    }
    
    private func authenticatePublisher<Output>(_ publisher: @escaping (String) -> some Publisher<Output, URLError>) -> AnyPublisher<Output, URLError> {
        
        if let jwt, isInPast8Hours(date: jwt.date) {
            return publisher(jwt.key).eraseToAnyPublisher()
        } else {
            return authenticate()
                .flatMap { token in
                    publisher(token)
                }
                .mapToURLError()
                .eraseToAnyPublisher()
        }
    }
    
    private func isInPast8Hours(date: Date) -> Bool {
        let jwtDateComponents = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day, .hour, .minute],
                                                                            from: date)
        let nowDateComponents = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day, .hour, .minute],
                                                                            from: dateHandler.today)
        
        let differences = [
            nowDateComponents.year! - jwtDateComponents.year!,
            nowDateComponents.month! - jwtDateComponents.month!,
            nowDateComponents.day! - jwtDateComponents.day!,
            nowDateComponents.hour! - jwtDateComponents.hour!,
            nowDateComponents.minute! - jwtDateComponents.minute!
        ]
        
        return  differences[0] <= 0 ||
                differences[1] <= 0 ||
                differences[2] <= 0 ||
                differences[3] <= 8 ||
                differences[3] == 8 && differences[4] <= 0
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
            return self.session.dataTaskPublisher(for: .sendADeck(jsonData), authToken: token)
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
