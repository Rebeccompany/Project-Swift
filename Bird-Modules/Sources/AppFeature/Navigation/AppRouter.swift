//
//  AppRouter.swift
//  
//
//  Created by Marcos Chevis on 23/11/22.
//

import Combine
import Puffins
import SwiftUI
import Models
import Storage
import Habitat

//swiftlint:disable trailing_closure
@MainActor
final class AppRouter: ObservableObject {
    @Published var path: NavigationPath = .init()
    @Published var storePath: NavigationPath = .init()
    @Published var selectedTab: Tab = .study
    
    private var decks: [Deck] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    @Dependency(\.externalDeckService) private var externalDeckService: ExternalDeckServiceProtocol
    
    private var fetchDeckPublisher: AnyPublisher<[Deck], Error> {
        deckRepository
            .deckListener()
            .first()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    init() {
        startup()
    }
    
    func startup() {
        deckRepository
            .deckListener()
            .sink { _ in
                
            } receiveValue: { [weak self] decks in
                guard let self else { return }
                self.decks = decks
            }
            .store(in: &cancellables)
    }
    
    func onOpen(url: URL) {
        let string = url.absoluteString
        var id: String = ""
        if string.count > 9 {
            id = String(string.suffix(string.count - 9))
        }
        
        if let deck = decks.first(where: { id == $0.storeId }) {
            navigate(to: deck)
        } else {
            navigateToStoreDeck(id: id)
        }
    }
    
    private func navigateToStoreDeck(id: String) {
        externalDeckService
            .downloadDeck(with: id)
            .map(DeckAdapter.adapt)
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak deckRepository] (deck: Deck, cards: [Card]) in
                try? deckRepository?.createDeck(deck, cards: cards)
            })
            .mapError {
                $0 as Error
            }
            .flatMap { [weak self] (_: Deck, _: [Card]) -> AnyPublisher<[Deck], Error> in
                guard let self else {
                    return Fail(outputType: [Deck].self, failure: RepositoryError.failedFetching as Error).eraseToAnyPublisher()
                }
                return self.fetchDeckPublisher
            }
            .compactMap { decks in
                decks.first { $0.storeId == id }
            }
            .sink { _ in
                
            } receiveValue: { [weak self] deck in
                guard let self else { return }
                self.navigate(to: deck)
            }
            .store(in: &cancellables)
    }
    
    private func navigate(to deck: Deck) {
        selectedTab = .study
        path.append(StudyRoute.deck(deck))
    }
}

extension AppRouter {
    enum Tab {
        case study, store
    }
}
