//
//  DeckCategoryModel.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/12/22.
//

import Foundation
import Models
import Habitat
import Combine
import Puffins

final class DeckCategoryModel: ObservableObject {
    
    @Published var decks: [ExternalDeck] = []
    @Published var viewState: ViewState = .loading
    @Published var shouldLoadMore: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    
    @Dependency(\.externalDeckService) private var deckService
    
    func startUp(with category: DeckCategory) {
        viewState = .loading
        decks = []
        loadDecks(from: category, page: 0)
    }
    
    func loadMoreDecks(from category: DeckCategory) {
        currentPage += 1
        loadDecks(from: category, page: currentPage)
    }
    
    private func loadDecks(from category: DeckCategory, page: Int) {
        deckService
            .decksByCategory(category: category, page: page)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.viewState = .loaded
                case .failure(_):
                    self?.viewState = .error
                }
            } receiveValue: { [weak self] decks in
                if decks.isEmpty || decks.count < 30 {
                    self?.shouldLoadMore = false
                }
                self?.decks.append(contentsOf: decks)
            }
            .store(in: &cancellables)

    }
}
