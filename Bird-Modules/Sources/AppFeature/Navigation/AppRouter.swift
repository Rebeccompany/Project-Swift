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
#if os(iOS)
    @Published var sidebarSelection: SidebarRoute? = .allDecks
#elseif os(macOS)
    @Published var sidebarSelection: SidebarRoute = .allDecks
#endif
    
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
        var routePath: String = ""
        if string.count > 9 {
            routePath = String(string.suffix(string.count - 9))
        }
        
        guard let route = generateRoute(urlPath: routePath) else {
            return
        }
        
        openRoute(route)
    }
    
    private func generateRoute(urlPath: String) -> DeepLinkRoute? {
        if urlPath.hasPrefix("store/") {
            return .openStore(storeId: String(urlPath.suffix(urlPath.count - "store/".count)))
        } else if urlPath.hasPrefix("opendeck/") {
            return .openDeck(storeId: String(urlPath.suffix(urlPath.count - "opendeck/".count)))
        } else if urlPath.hasPrefix("openlocaldeck/") {
            return .openLocalDeck(id: String(urlPath.suffix(urlPath.count - "openlocaldeck/".count)))
        } else {
            //Rota de 404
            return nil
        }
    }
    
    private func openRoute(_ route: DeepLinkRoute) {
        switch route {
        case .openDeck(let storeId):
            openDeck(storeId)
        case .openStore(let storeId):
            openStore(storeId)
        case .openLocalDeck(let id):
            openLocalDeck(id)
        }
    }
    
    private func openDeck(_ id: String) {
        if let deck = decks.first(where: { id == $0.storeId }) {
            navigate(to: deck)
        } else {
            navigateToStoreDeck(id: id)
        }
    }
    
    private func openStore(_ id: String) {
        externalDeckService.getDeck(by: id)
            .receive(on: RunLoop.main)
            .sink { _ in
                
            } receiveValue: {[weak self] deck in
                self?.selectedTab = .store
                self?.sidebarSelection = .store
                if let count = self?.storePath.count, count >= 1 {
                    self?.storePath.removeLast(count)
                }
                self?.storePath.append(deck)
            }
            .store(in: &cancellables)

    }
    
    private func openLocalDeck(_ id: String) {
        if let deck = decks.first(where: { id == $0.id.uuidString }) {
            navigate(to: deck)
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
        self.sidebarSelection = .allDecks
        selectedTab = .study
        if !path.isEmpty {
            path.removeLast(path.count)
        }
        path.append(StudyRoute.deck(deck))
    }
}

extension AppRouter {
    enum Tab {
        case study, store
    }
    
    enum DeepLinkRoute {
        case openDeck(storeId: String)
        case openStore(storeId: String)
        case openLocalDeck(id: String)
    }
}
