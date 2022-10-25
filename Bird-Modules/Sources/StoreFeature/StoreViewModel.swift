//
//  StoreViewModel.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import Models
import HummingBird
import Combine
import DeckFeature
import Storage
import Habitat
import SwiftUI
import Puffins

public class StoreViewModel: ObservableObject {
    @Published var searchFieldContent: String
    @Published var decks: [DeckCategory: [ExternalDeck]]
    @Published var sortOrder: [KeyPathComparator<Deck>]
    
    private var externalDeckService: ExternalDeckServiceProtocol = ExternalDeckServiceMock()
    
    public init() {
        self.searchFieldContent = ""
        self.decks = [:]
        self.sortOrder = [KeyPathComparator(\Deck.name)]
    }
    
    private var deckListener: AnyPublisher<[DeckCategory: [ExternalDeck]], URLError> {
        externalDeckService.getDeckFeed()
    }
    
    func startup() {
        deckListener
            .assertNoFailure()
            .assign(to: &$decks)
    }
    
    private func filterDecksBySearchText(_ decks: [Deck], searchText: String) -> [Deck] {
        if searchText.isEmpty {
            return decks
        } else {
            return decks.filter { $0.name.capitalized.contains(searchText.capitalized) }
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
}
