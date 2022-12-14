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
    func uploadNewDeck(_ deck: Deck, with cards: [Card], owner: User) -> AnyPublisher<String, URLError>
    func updateADeck(_ deck: Deck, with cards: [Card], owner: User) -> AnyPublisher<Void, URLError>
    func deleteDeck(_ deck: Deck) -> AnyPublisher<Void, URLError>
    func downloadDeck(with id: String) -> AnyPublisher<DeckDTO, URLError>
    func deleteAllDeckFromUser(id: String) -> AnyPublisher<Void, URLError>
    func searchDecks(type: String, value: String, page: Int) -> AnyPublisher<[ExternalDeck], URLError>
    func decksByCategory(category: DeckCategory, page: Int) -> AnyPublisher<[ExternalDeck], URLError>
}
