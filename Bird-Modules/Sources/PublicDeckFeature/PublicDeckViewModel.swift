//
//  File.swift
//  
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation
import Models
import HummingBird
import Combine
import Storage
import Woodpecker
import Habitat
import Utils

public class PublicDeckViewModel: ObservableObject {
    @Published var cards: [Card]
    
    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    
    public init() {
        self.cards = []
    }
    
    private func cardListener(_ deck: Deck) -> AnyPublisher<[Card], Never> {
        deckRepository
            .cardListener(forId: deck.id)
            .replaceError(with: [])
            .map { cards in cards.sorted { c1, c2 in c1.datesLogs.createdAt > c2.datesLogs.createdAt } }
            .eraseToAnyPublisher()
    }
    
    func deckListener(_ deck: Deck) -> AnyPublisher<Deck, RepositoryError> {
        deckRepository
            .cardListener(forId: deck.id)
            .flatMap {[weak self, deck] _ in
                guard let self = self else {
                    return Fail<Deck, RepositoryError>(error: .errorOnListening).eraseToAnyPublisher()
                }
                
                return self.deckRepository.fetchDeckById(deck.id)
            }
            .eraseToAnyPublisher()
    }
    
    func startup(_ deck: Deck) {
        cardListener(deck)
            .assign(to: &$cards)
        
        var deck = deck
        deck.datesLogs.lastAccess = dateHandler.today
        try? deckRepository.editDeck(deck)
    }
}
