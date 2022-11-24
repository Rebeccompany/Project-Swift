//
//  File.swift
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


enum PublicDeckActions: Equatable {
    case loadDeck(id: String)
    case loadCards(id: String, page: Int)
    case reloadCards(id: String)
    case downloadDeck(id: String)
    case exitDeck
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
        case .exitDeck:
            return Just(PublicDeckState()).eraseToAnyPublisher()
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
    
    //swiftlint:disable trailing_closure
    private func downloadCardsEffect(_ currentState: PublicDeckState, id: String) -> some Publisher<PublicDeckState, Never> {
        deckService
            .downloadDeck(with: id)
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
