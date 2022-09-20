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
    
    //MARK: Collections
    @Published var collections: [DeckCollection]
    @Published var decks: [Deck]
    
    //MARK: CRUD Published
    @Published var editingDeck: Deck?
    @Published var editingCollection: DeckCollection?
    
    //MARK: View Bindings
    @Published var sidebarSelection: SidebarRoute? = .allDecks
    @Published var selection: Set<Deck.ID>
    @Published var searchText: String
    @Published var detailType: DetailDisplayType
    @Published var sortOrder: [KeyPathComparator<Deck>]

    //MARK: Repositories
    private let collectionRepository: CollectionRepositoryProtocol
    private let deckRepository: DeckRepositoryProtocol
    private var cancellables: Set<AnyCancellable>
    
    var detailTitle: String {
        switch sidebarSelection ?? .allDecks {
        case .allDecks:
            return "Todas as coleções"
        case .decksFromCollection(let collection):
            return collection.name
        }
    }
    
    public init(
        collectionRepository: CollectionRepositoryProtocol = CollectionRepository.shared,
        deckRepository: DeckRepositoryProtocol = DeckRepository.shared
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
            .handleEvents(receiveCompletion: handleCompletion)
            .replaceError(with: [])
            .assign(to: &$collections)
        
        deckRepository
            .deckListener()
            .handleEvents(receiveCompletion: handleCompletion)
            .replaceError(with: [])
            .combineLatest($sidebarSelection)
            .map(mapDecksBySidebarSelection)
            .combineLatest($searchText)
            .map(filterDecksBySearchText)
            .assign(to: &$decks)
        
    }
    
    private func mapDecksBySidebarSelection(decks: [Deck], sidebarSelection: SidebarRoute?) -> [Deck] {
        switch sidebarSelection ?? .allDecks {
            
        case .allDecks:
            return decks
        case .decksFromCollection(let collection):
            return decks.filter { deck in
                deck.collectionId == collection.id
            }
        }
    }
            
    private func filterDecksBySearchText(_ decks: [Deck], searchText: String) -> [Deck] {
        if searchText.isEmpty {
            return decks
        } else {
            return decks.filter { $0.name.capitalized.contains(searchText.capitalized) }
        }
    }
    
    private func handleEndEditing(_ isPresenting: Bool ) {
        if !isPresenting {
            self.editingCollection = nil
        }
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error)
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
