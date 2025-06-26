//
//  ContentInteractor.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 23/06/25.
//

import Habitat
import Models
import Foundation

protocol ContentInteractorProtocol {
    func allDecks() -> any AsyncSequence<[Deck], Never>
    func allCollections() -> any AsyncSequence<[DeckCollection], Never>
    func deleteDeck(_ deck: Deck) throws
    func deleteCollection(_ collection: DeckCollection) throws
    func deleteDecks(_ decks: [Deck]) throws
    func change(
        deck: Deck,
        to collection: DeckCollection?,
        collections: [DeckCollection]
    )
}

final class ContentInteractor: ContentInteractorProtocol {
    @Dependency(\.deckRepository) private var deckRepository
    @Dependency(\.collectionRepository) private var collectionRepository
    @Dependency(\.notificationCenter) private var notificationCenter

    func allDecks() -> any AsyncSequence<[Deck], Never> {
        deckRepository
            .deckListener()
            .replaceError(with: [])
            .values
    }

    func allCollections() -> any AsyncSequence<[DeckCollection], Never> {
        collectionRepository
            .listener()
            .replaceError(with: [])
            .values
    }

    func deleteDeck(_ deck: Deck) throws {
        try deckRepository.deleteDeck(deck)
    }

    func deleteDecks(_ decks: [Deck]) throws {
        try decks.forEach { deck in
            try deckRepository.deleteDeck(deck)
        }
    }

    func deleteCollection(_ collection: DeckCollection) throws {
        try collectionRepository.deleteCollection(collection)
    }

    func change(
        deck: Deck,
        to collection: DeckCollection?,
        collections: [DeckCollection]
    ) {
        if let collection {
            try? collectionRepository.addDeck(deck, in: collection)
        } else if let collectionId = deck.collectionId, let collection = collections.first(where: { $0.id == collectionId }) {
            try? collectionRepository.removeDeck(deck, from: collection)
        }
    }
}
