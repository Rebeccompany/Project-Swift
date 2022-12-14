//
//  StoreViewModel.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import Models
import Foundation
import Combine
import Habitat
import Puffins
import Peacock
import StoreState

final class FeedInteractor: Interactor {
    
    @Dependency(\.externalDeckService) private var externalDeckService: ExternalDeckServiceProtocol
    private let actionDispatcher: PassthroughSubject<FeedAction, Never>
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.actionDispatcher = PassthroughSubject()
        self.cancellables = Set()
    }
    
    func send(_ action: FeedAction) {
        actionDispatcher.send(action)
    }
    
    func bind(to store: ShopStore) {
        actionDispatcher
            .receive(on: RunLoop.main)
            .flatMap { [weak self, weak store] action -> AnyPublisher<FeedState, Never> in
                guard let self, let store else {
                    preconditionFailure("Store is deinit")
                }
                return self.reduce(&store.feedState, action: action)
            }
            .sink {[weak store] newState in
                guard newState != store?.feedState else { return }
                store?.feedState = newState
            }
            .store(in: &cancellables)
    }
    
    func reduce(_ currentState: inout FeedState, action: FeedAction) -> AnyPublisher<FeedState, Never> {
        switch action {
        case .loadFeed:
            currentState.viewState = .loading
            currentState.sections = []
            return loadFeedEffect(currentState: currentState)
        }
    }
    
    private func loadFeedEffect(currentState: FeedState) -> AnyPublisher<FeedState, Never> {
        externalDeckService
            .getDeckFeed()
            .receive(on: RunLoop.main)
            .map { newSections in
                var newState = currentState
                newState.sections = newSections
                newState.viewState = .loaded
                return newState
            }
            .replaceError(with: {
                var errorState = currentState
                errorState.viewState = .error
                return errorState
            }())
            .eraseToAnyPublisher()
    }
}
