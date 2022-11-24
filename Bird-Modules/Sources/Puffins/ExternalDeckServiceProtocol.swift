//
//  APIServiceProtocol.swift
//  
//
//  Created by Rebecca Mello on 24/10/22.
//

import Foundation
import Combine
import Models

public protocol ExternalDeckServiceProtocol {
    func getDeckFeed() -> AnyPublisher<[ExternalSection], URLError>
    func getCardsFor(deckId: String, page: Int) -> AnyPublisher<[ExternalCard], URLError>
    func getDeck(by id: String) -> AnyPublisher<ExternalDeck, URLError>
    func uploadNewDeck(_ deck: Deck, with cards: [Card]) -> AnyPublisher<String, URLError>
    func deleteDeck(_ deck: Deck) -> AnyPublisher<Void, URLError>
    func downloadDeck(with id: String) -> AnyPublisher<DeckDTO, URLError>
}
