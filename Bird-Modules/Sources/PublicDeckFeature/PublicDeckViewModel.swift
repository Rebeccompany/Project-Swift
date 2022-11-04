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

public protocol Interactor: ObservableObject {
    associatedtype Action
    associatedtype State
    associatedtype Result
    
    func send(_ action: Action)
    func bind(to store: Store<State>)
    func reduce(_ previousState: State, action: Result) -> State
}

enum PublicDeckActions {
    case loadDeck(id: String)
    case loadCards(id: String, page: Int)
    case reloadCards(id: String)
}

enum PublickDeckResult {
    case deckIsLoaded(deck: ExternalDeck)
    case loadCards(cards: [ExternalCard])
    case reloadCards(cards: [ExternalCard])
}

struct PublicDeckState {
    var deck: ExternalDeck? = nil
    var cards: [ExternalCard] = []
    var currentPage: Int = 0
}

public final class Store<State>: ObservableObject {
 
    @Published var state: State
    
    init(state: State) {
        self.state = state
    }
}

final class PublicDeckInteractor: Interactor {
    
    @Dependency(\.externalDeckService) var deckService
    
    private var actionDispatcher: PassthroughSubject<PublickDeckResult, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ action: PublicDeckActions) {
        switch action {
        case .loadDeck(let id):
            deckService
                .getDeck(by: id)
                .map { PublickDeckResult.deckIsLoaded(deck: $0) }
                .sink { _ in
                    
                } receiveValue: { [weak self] result in
                    self?.actionDispatcher.send(result)
                }
                .store(in: &cancellables)
                
        case .loadCards(let id, let page):
            deckService
                .getCardsFor(deckId: id, page: page)
                .replaceError(with: [])
                .map { PublickDeckResult.loadCards(cards: $0) }
                .sink { [weak self] action in
                    self?.actionDispatcher.send(action)
                }
                .store(in: &cancellables)
            
        case .reloadCards(let id):
            deckService
                .getCardsFor(deckId: id, page: 0)
                .replaceError(with: [])
                .map { PublickDeckResult.reloadCards(cards: $0) }
                .sink { [weak self] action in
                    self?.actionDispatcher.send(action)
                }
                .store(in: &cancellables)
        }
    }
    
    func bind(to store: Store<PublicDeckState>) {
        actionDispatcher
            .compactMap { [weak self, weak store] (action) -> PublicDeckState? in
                guard let self, let store else { return nil }
                return self.reduce(store.state, action: action)
            }
            .assign(to: &store.$state)
    }
    
    func reduce(_ previousState: PublicDeckState, action: PublickDeckResult) -> PublicDeckState {
        var newState = previousState
        
        switch action {
        case .deckIsLoaded(let deck):
            newState.deck = deck
        case .loadCards(let cards):
            newState.cards += cards
            newState.currentPage += 1
        case .reloadCards(let cards):
            newState.cards = cards
        }
        
        return newState
    }

}

public class PublicDeckViewModel: ObservableObject {

    @Dependency(\.externalDeckService) var deckService
    
    @Published var cards: [ExternalCard] = []
    @Published var currentPage: Int = 0
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    func fetchCards(deckId: String) {
        deckService
            .getCardsFor(deckId: deckId, page: currentPage)
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: {[weak self] completion in
                if completion == .finished {
                    self?.currentPage += 1
                } else {
                    self?.currentPage = 0
                }
            })
            .sink { completion in
                
            } receiveValue: {[weak self] newCards in
                self?.cards.append(contentsOf: newCards)
            }
            .store(in: &cancellables)

    }
    
    func reloadCards(deckId: String) {
        deckService
            .getCardsFor(deckId: deckId, page: 0)
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: {[weak self] _ in self?.currentPage = 0 })
            .sink { completion in
                
            } receiveValue: {[weak self] cards in
                self?.cards = cards
            }
            .store(in: &cancellables)
    }
}
