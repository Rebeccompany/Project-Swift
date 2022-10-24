//
//  ExternalDeckServiceMock.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation
import Models
import Combine

final class ExternalDeckServiceMock: ExternalDeckServiceProtocol {
    
    var feed: [DeckCategory : [ExternalDeck]] = [
        .stem : [],
        .humanities: [],
        .languages: [],
        .arts: [],
        .others: []
    ]
    
    func getDeckFeed() -> AnyPublisher<[DeckCategory : [ExternalDeck]], URLError> {
        Just(feed).setFailureType(to: URLError.self).eraseToAnyPublisher()
    }
}
