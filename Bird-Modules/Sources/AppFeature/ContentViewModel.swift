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
    @Published var presentCollectionEdition: Bool = false
    @Published var editingCollection: DeckCollection?
    
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
    }
    
    func startup() {
        collectionRepository
            .listener()
            .sink(
                receiveCompletion: handleCollectionCompletion,
                receiveValue: handleReceiveCollections
            )
            .store(in: &cancellables)
        
        $presentCollectionEdition
            .filter { !$0 }
            .receive(on: RunLoop.main)
            .sink(receiveValue: handleEndEditing)
            .store(in: &cancellables)
        
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
        case .failure(let failure):
            fatalError(failure.localizedDescription)
        }
    }
    
    private func handleReceiveCollections(_ collections: [DeckCollection]) {
        self.collections = collections
    }
    
    func deleteCollection(at index: IndexSet) {
        let collections = self.collections
        let collectionsToDelete = index.map { i in collections[i] }
        
        do {
            try collectionsToDelete.forEach { collection in
                try collectionRepository.deleteCollection(collection)
            }
        } catch {
            print("oi")
        }
    }
    
    func editCollection(_ collection: DeckCollection) {
        editingCollection = collection
        presentCollectionEdition = true
    }
    
    func createCollection() {
        editingCollection = nil
        presentCollectionEdition = true
    }
    
}
