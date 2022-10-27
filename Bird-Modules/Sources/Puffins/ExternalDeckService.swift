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
    private let session: URLSession
    
    public static let shared: ExternalDeckService = .init()
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func getDeckFeed() -> AnyPublisher<[ExternalSection], URLError> {
        session.dataTaskPublisher(for: Endpoint.feed.url)
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
}
