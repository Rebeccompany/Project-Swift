//
//  DeckCategoryView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/12/22.
//

import SwiftUI
import Models
import Habitat
import Combine
import Utils
import Puffins

#warning("Localizar e Testes")
struct DeckCategoryView: View {
    
    let category: DeckCategory
    @StateObject private var model = DeckCategoryModel()
    
    var body: some View {
        Group {
            switch model.viewState {
            case .loaded:
                ScrollView {
                    LazyVStack {
                        Section {
                            ForEach(model.decks) { deck in
                                NavigationLink(value: deck) {
                                    SearchDeckCell(deck: deck)
                                }
                            }
                        } footer: {
                            if model.shouldLoadMore {
                                ProgressView()
                                    .onAppear {
                                        model.loadMoreDecks(from: category)
                                    }
                            }
                        }

                    }
                    .padding(.top)
                }
            case .loading:
                LoadingView()
            case .error:
                ErrorView {
                    model.startUp(with: category)
                }
            }
        }
        .refreshable {
            model.startUp(with: category)
        }
        .navigationTitle(category.rawValue.localized(.module))
        .onAppear {
            model.startUp(with: category)
        }
    }
    
}

final class DeckCategoryModel: ObservableObject {
    
    @Published var decks: [ExternalDeck] = []
    @Published var viewState: ViewState = .loading
    @Published var shouldLoadMore: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 0
    
    private var deckService : ExternalDeckServiceMock = .init()
    
    init() {
        deckService.error = URLError(.badServerResponse)
        deckService.shouldError = true
        
    }
    
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
            .delay(for: .seconds(1), scheduler: RunLoop.main)
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

struct DeckCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                DeckCategoryView(category: .humanities)
            }
        }
    }
}
