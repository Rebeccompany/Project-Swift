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
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func getDeckFeed() -> AnyPublisher<[DeckCategory : [ExternalDeck]], URLError> {
        session.dataTaskPublisher(for: URL(string: "https://www.google.com.br")!)
            .map(\.data)
            .decode(type: [DeckCategory: [ExternalDeck]].self, decoder: JSONDecoder())
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
