//
//  PublicDeckInteractor.swift
//  
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation
import Models
import Combine
import Habitat
import Peacock
import StoreState

final class PublicDeckModel: ObservableObject {
    @Dependency(\.externalDeckService) private var deckService
    @Dependency(\.deckRepository) private var deckRepository
    
    @Published var deck: ExternalDeck?
    @Published var cards: [ExternalCard]
    @Published var currentPage: Int
    @Published var shouldLoadMore: Bool
    @Published var viewState: ViewState
    @Published var shouldDisplayDownloadedAlert: Bool
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        deck: ExternalDeck? = nil,
        cards: [ExternalCard] = [],
        currentPage: Int = 0,
        shouldLoadMore: Bool = true,
        viewState: ViewState = .loading,
        shouldDisplayDownloadedAlert: Bool = false) {
        self.deck = deck
        self.cards = cards
        self.currentPage = currentPage
        self.shouldLoadMore = shouldLoadMore
        self.viewState = viewState
        self.shouldDisplayDownloadedAlert = shouldDisplayDownloadedAlert
    }
    
    func startUp(id: String) {
        loadDeck(id: id)
    }
    
    func loadMoreCards() {
        guard let deck, let id = deck.id else { return }
        currentPage += 1
        
        deckService
            .getCardsFor(deckId: id, page: currentPage)
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink {[weak self] cards in
                self?.cards.append(contentsOf: cards)
                self?.shouldLoadMore = !cards.isEmpty
            }
            .store(in: &cancellables)

        
    }
    
    func reloadCards() {
        guard let deck, let id = deck.id else { return }
        currentPage = 0
        
        deckService
            .getCardsFor(deckId: id, page: currentPage)
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .sink {[weak self] cards in
                self?.cards = cards
                self?.shouldLoadMore = !cards.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func downloadDeck() {
        guard let deck, let id = deck.id else { return }
        deckService.downloadDeck(with: id)
            .map(DeckAdapter.adapt)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.viewState = .loaded
                    self?.shouldDisplayDownloadedAlert = true
                case .failure(_):
                    self?.viewState = .error
                }
            } receiveValue: {[weak deckRepository] deck, cards in
                try? deckRepository?.createDeck(deck, cards: cards)
            }
            .store(in: &cancellables)
    }
    
    private func loadDeck(id: String) {
        viewState = .loading
        
        return deckService
            .getDeck(by: id)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                switch completion {
                case .finished:
                    self?.viewState = .loaded
                case .failure(_):
                    self?.viewState = .error
                }
            } receiveValue: {[weak self] deck in
                self?.deck = deck
                self?.reloadCards()
            }
            .store(in: &cancellables)
    }
    
}

final class PublicDeckInteractor: Interactor {
    
    @Dependency(\.externalDeckService) private var deckService
    @Dependency(\.deckRepository) private var deckRepository
    
    private var actionDispatcher: PassthroughSubject<PublicDeckActions, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ action: PublicDeckActions) {
        actionDispatcher.send(action)
    }
    
    func bind(to store: ShopStore) {
        actionDispatcher
            .receive(on: RunLoop.main)
            .flatMap { [weak self, weak store] action -> AnyPublisher<PublicDeckState, Never> in
                guard let self, let store else {
                    preconditionFailure("there is no Store or Error")
                }
                return self.reduce(&store.deckState, action: action)
            }
            .replaceError(with: store.deckState)
            .sink { _ in
                
            } receiveValue: { [weak store] newState in
                DispatchQueue.main.async {
                    store?.deckState = newState
                }
            }
            .store(in: &cancellables)
    }
    
    func reduce( _ currentState: inout PublicDeckState, action: PublicDeckActions) -> AnyPublisher<PublicDeckState, Never> {
        switch action {
        case .loadDeck(let id):
            currentState.viewState = .loading
            return loadDeckEffect(id: id, currentState: currentState)
        case .loadCards(let id, let page):
            currentState.currentPage += 1
            return loadNewCardsEffect(currentState, id: id, page: page)
        case .reloadCards(let id):
            currentState.cards = []
            currentState.currentPage = 0
            return reloadCardsEffect(currentState, id: id)
        case .downloadDeck(let id):
            currentState.viewState = .loading
            return downloadCardsEffect(currentState, id: id).eraseToAnyPublisher()
        }
    }
    
    private func loadDeckEffect(id: String, currentState: PublicDeckState) -> AnyPublisher<PublicDeckState, Never> {
        deckService
            .getDeck(by: id)
            .map { deck in
                var newState = currentState
                newState.deck = deck
                newState.viewState = .loaded
                return newState
            }
            .replaceError(with: {
                var newState = currentState
                newState.viewState = .error
                return newState
            }())
            .eraseToAnyPublisher()
    }
    
    private func loadNewCardsEffect(_ currentState: PublicDeckState, id: String, page: Int) -> AnyPublisher<PublicDeckState, Never> {
        deckService
            .getCardsFor(deckId: id, page: page)
            .map { cards in
                var newState = currentState
                newState.cards += cards
                newState.currentPage += 1
                newState.shouldLoadMore = !cards.isEmpty
                return newState
            }
            .replaceError(with: {
                var newState = currentState
                newState.viewState = .error
                return newState
            }())
            .eraseToAnyPublisher()
    }
    
    private func reloadCardsEffect(_ currentState: PublicDeckState, id: String) -> AnyPublisher<PublicDeckState, Never> {
        deckService
            .getCardsFor(deckId: id, page: 0)
            .map { cards in
                var newState = currentState
                newState.cards = cards
                newState.shouldLoadMore = !cards.isEmpty
                newState.currentPage = 1
                return newState
            }
            .replaceError(with: {
                var newState = currentState
                newState.viewState = .error
                return newState
            }())
            .eraseToAnyPublisher()
    }
    
    //swiftlint: disable trailing_closure
    private func downloadCardsEffect(_ currentState: PublicDeckState, id: String) -> some Publisher<PublicDeckState, Never> {
        deckService.downloadDeck(with: id)
            .map(DeckAdapter.adapt)
            .handleEvents(receiveOutput: {[weak deckRepository] deck, cards in
                try? deckRepository?.createDeck(deck, cards: cards)
            })
            .map { _ in
                var newState = currentState
                newState.viewState = .loaded
                newState.shouldDisplayDownloadedAlert = true
                return newState
            }
            .replaceError(with: {
                var newState = currentState
                newState.viewState = .error
                return newState
            }())
    }
}
