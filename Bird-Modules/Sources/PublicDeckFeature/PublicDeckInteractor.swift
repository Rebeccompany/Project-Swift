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
    case exitDeck
}

final class PublicDeckInteractor: Interactor {
    
    @Dependency(\.externalDeckService) var deckService
    
    private var actionDispatcher: PassthroughSubject<PublicDeckActions, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ action: PublicDeckActions) {
        actionDispatcher.send(action)
    }
    
    func bind(to store: ShopStore) {
        actionDispatcher
            .receive(on: RunLoop.main)
            .flatMap { [weak self, weak store] action -> AnyPublisher<PublicDeckState, Error> in
                guard let self, let store else {
                    return Fail(outputType: PublicDeckState.self, failure: NSError()).eraseToAnyPublisher()
                }
                return self.reduce(&store.deckState, action: action)
            }
            .sink { _ in
                
            } receiveValue: { [weak store] newState in
                DispatchQueue.main.async {
                    store?.deckState = newState
                }
            }
            .store(in: &cancellables)
    }
    
    func reduce( _ currentState: inout PublicDeckState, action: PublicDeckActions) -> AnyPublisher<PublicDeckState, Error> {
        switch action {
        case .loadDeck(let id):
            return loadDeckEffect(id: id, currentState: currentState)
        case .loadCards(let id, let page):
            currentState.currentPage += 1
            return loadNewCardsEffect(currentState, id: id, page: page)
        case .reloadCards(let id):
            currentState.cards = []
            currentState.currentPage = 0
            return reloadCardsEffect(currentState, id: id)
        case .exitDeck:
            return Just(PublicDeckState()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    private func loadDeckEffect(id: String, currentState: PublicDeckState) -> AnyPublisher<PublicDeckState, Error> {
        deckService
            .getDeck(by: id)
            .map { deck in
                var newState = currentState
                newState.deck = deck
                return newState
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func loadNewCardsEffect(_ currentState: PublicDeckState, id: String, page: Int) -> AnyPublisher<PublicDeckState, Error> {
        deckService
            .getCardsFor(deckId: id, page: page)
            .map { cards in
                var newState = currentState
                newState.cards += cards
                newState.currentPage += 1
                newState.shouldLoadMore = !cards.isEmpty
                return newState
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    private func reloadCardsEffect(_ currentState: PublicDeckState, id: String) -> AnyPublisher<PublicDeckState, Error> {
        deckService
            .getCardsFor(deckId: id, page: 0)
            .map { cards in
                var newState = currentState
                newState.cards = cards
                newState.currentPage = 1
                return newState
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
