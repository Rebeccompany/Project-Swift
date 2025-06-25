//
//  DeckInteractor.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 23/06/25.
//

import Storage
import Habitat
import Models
import Foundation

final class DeckInteractor {
    @Dependency(\.deckRepository) private var repository
    @Dependency(\.dateHandler) private var dateHandler
    
    func cardListener(for deck: Deck) -> some AsyncSequence<[Card], Error> {
        repository.cardListener(forId: deck.id).values
    }

    func fetchDeck(_ id: UUID) -> Deck? {
        try? repository.fetchDeckById(id)
    }

    func canStudySpixiiMode(for deck: Deck) -> Bool {
        if deck.cardsIds.isEmpty { return false }
        guard let session = deck.session else { return true }
        guard !session.cardIds.isEmpty,
            let isToday = try? dateHandler.isToday(date: session.date)
        else { return false }

        return isToday || session.date < dateHandler.today
    }
}
