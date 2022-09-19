//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import Foundation
import Models
import Combine
import Storage
import DeckFeature

public final class ContentViewModel: ObservableObject {
    
    @Published var collections: [DeckCollection]
    @Published var sidebarSelection: SidebarRoute? = .allDecks
    @Published var decks: [Deck]
    @Published var editingCollection: DeckCollection?
    @Published var selection: Set<Deck.ID>
    @Published var searchText: String
    @Published var detailType: DetailDisplayType
    @Published var sortOrder: [KeyPathComparator<Deck>]
    @Published var editingDeck: Deck?

    
    private let collectionRepository: CollectionRepositoryProtocol
    private let deckRepository: DeckRepositoryProtocol
    private var cancellables: Set<AnyCancellable>
    
    public init(
        collectionRepository: CollectionRepositoryProtocol = CollectionRepositoryMock.shared,
        deckRepository: DeckRepositoryProtocol = DeckRepositoryMock.shared
    ) {
        self.collectionRepository = collectionRepository
        self.deckRepository = deckRepository
        self.collections = []
        self.cancellables = .init()
        self.decks = []
        self.selection = .init()
        self.searchText = ""
        self.detailType = .grid
        self.sortOrder = [KeyPathComparator(\Deck.name)]
    }
    
    func startup() {
        collectionRepository
            .listener()
            .handleEvents(receiveCompletion: handleCollectionCompletion)
            .replaceError(with: [])
            .assign(to: &$collections)
        
        deckRepository
            .deckListener()
            .replaceError(with: [])
            .combineLatest($sidebarSelection)
            .map(mapDecksBySidebarSelection)
            .assign(to: &$decks)
        
    }
    
    private func mapDecksBySidebarSelection(decks: [Deck], sidebarSelection: SidebarRoute?) -> [Deck] {
        switch sidebarSelection ?? .allDecks {
            
        case .allDecks:
            return decks
        case .decksFromCollection(let id):
            return decks.filter { deck in
                deck.collectionsIds.contains(id)
            }
        }
    }
    
    private func handleEndEditing(_ isPresenting: Bool ) {
        if !isPresenting {
            self.editingCollection = nil
        }
    }
    
    private func handleCollectionCompletion(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            print("finished")
        case .failure(_):
            print("error")
        }
    }
    
    func deleteCollection(at index: IndexSet) throws {
        let collections = self.collections
        let collectionsToDelete = index.map { i in collections[i] }
        
        try collectionsToDelete.forEach { collection in
            try collectionRepository.deleteCollection(collection)
        }
    }
    
    func editCollection(_ collection: DeckCollection) {
        editingCollection = collection
    }
    
    func createCollection() {
        editingCollection = nil
    }
    
    func deleteDecks() {
        self.decks.filter { deck in
            selection.contains(deck.id)
        }
        .forEach { deck in
            try? deckRepository.deleteDeck(deck)
        }
    }
    
    func createDecks() {
        editingDeck = nil
    }
}
