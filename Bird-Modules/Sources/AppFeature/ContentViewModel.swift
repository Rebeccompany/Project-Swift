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

public final class ContentViewModel: ObservableObject {
    
    @Published var collections: [DeckCollection]
    @Published var sidebarSelection: SidebarRoute? = .allDecks
    @Published var decks: [Deck]
    
    private let collectionRepository: CollectionRepositoryProtocol
    private let deckRepository: DeckRepositoryProtocol
    private var cancellables: Set<AnyCancellable>
    
    public init(
        collectionRepository: CollectionRepositoryProtocol = CollectionRepositoryMock(),
        deckRepository: DeckRepositoryProtocol = DeckRepositoryMock()
    ) {
        self.collectionRepository = collectionRepository
        self.deckRepository = deckRepository
        self.collections = []
        self.cancellables = .init()
        self.decks = []
    }
    
    func startup() {
        collectionRepository
            .listener()
            .sink(
                receiveCompletion: handleCollectionCompletion,
                receiveValue: handleReceiveCollections
            )
            .store(in: &cancellables)
        
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
    
    private func handleCollectionCompletion(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            print("finished")
        case .failure(let failure):
            fatalError(failure.localizedDescription)
        }
    }
    
    private func handleReceiveCollections(_ collections: [DeckCollection]) {
        self.collections = collections
    }
}
