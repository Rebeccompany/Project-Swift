//
//  ContentViewModel.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import Foundation
import Models
import Combine
import Storage
import DeckFeature
import Habitat
import Utils
import SwiftUI
import Tweet
import Puffins

//swiftlint:disable trailing_closure
public final class ContentViewModel: ObservableObject {
    
    // MARK: Collections
    @Published var collections: [DeckCollection]
    @Published var decks: [Deck]
    @Published var todayDecks: [Deck]
    @Published var selection: Set<Deck.ID>
    @Published var searchText: String
    @Published var detailType: DetailDisplayType
    @Published var sortOrder: [KeyPathComparator<Deck>]
    @Published var shouldReturnToGrid: Bool
    @Published var selectedCollection: DeckCollection?
    
    
    // MARK: Repositories
    @Dependency(\.collectionRepository) private var collectionRepository: CollectionRepositoryProtocol
    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    @Dependency(\.displayCacher) private var displayCacher: DisplayCacherProtocol
    @Dependency(\.notificationService) private var notificationService: NotificationServiceProtocol
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    @Dependency(\.externalDeckService) private var externalDeckService: ExternalDeckServiceProtocol
    @Dependency(\.notificationCenter) private var notificationCenter: NotificationCenterProtocol
    
    private var cancellables: Set<AnyCancellable>
    
    var detailTitle: String {
        if let selectedCollection {
            return selectedCollection.name
        } else {
            return NSLocalizedString("baralhos_title", bundle: .module, comment: "")
        }
    }
    
    public init() {
        self.collections = []
        self.cancellables = .init()
        self.decks = []
        self.todayDecks = []
        self.selection = .init()
        self.searchText = ""
        self.detailType = .grid
        self.shouldReturnToGrid = true
        self.sortOrder = [KeyPathComparator(\Deck.name)]
    }
    
    private var collectionListener: AnyPublisher<[DeckCollection], Never> {
        collectionRepository
            .listener()
            .handleEvents(receiveCompletion: { [weak self] completion in self?.handleCompletion(completion) })
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    private var deckListener: AnyPublisher<[Deck], Never> {
        deckRepository
            .deckListener()
            .handleEvents(receiveCompletion: { [weak self] completion in self?.handleCompletion(completion) })
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var filteredDecks: [Deck] {
        let filteredBySelection = mapDecksBySidebarSelection(decks: decks, selectedCollection: selectedCollection)
        let filteredBySearch = filterDecksBySearchText(filteredBySelection, searchText: searchText)
        return filteredBySearch
    }
    
    func startup() {
        collectionListener
            .assign(to: &$collections)
        
        deckListener
            .assign(to: &$decks)
        
        detailType = displayCacher.getCurrentDetailType() ?? .grid
        shouldReturnToGrid = detailType == .grid
        
        notificationService.requestAuthorizationForNotifications()
        
        setupDidEnterForeground()
        setupDidEnterBackgroundPublisher()
        notificationService.cleanNotifications()
        
        $decks
            .tryMap(filterDecksForToday)
            .replaceError(with: [])
            .receive(on: RunLoop.main)
            .assign(to: &$todayDecks)
    }
    
    private func setupDidEnterForeground() {
#if os(iOS)
        let notification = UIApplication.willEnterForegroundNotification
#elseif os(macOS)
        var notification = NSApplication.didBecomeActiveNotification
#endif
        notificationCenter
            .notificationPublisher(for: notification, object: nil)
            .receive(on: RunLoop.main)
            .sink { _ in
                self.notificationService.cleanNotifications()
            }
            .store(in: &cancellables)
    }
    
    private func setupDidEnterBackgroundPublisher() {
        #if os(iOS)
        let notification = UIApplication.didEnterBackgroundNotification
        #elseif os(macOS)
        var notification = NSApplication.didResignActiveNotification
        #endif
        notificationCenter
            .notificationPublisher(for: notification, object: nil)
            .receive(on: RunLoop.main)
            .flatMap { [weak self] _ in
                guard let self else {
                    preconditionFailure("self is deinitialized")
                }
                return self.deckRepository.deckListener().first()
            }
            .replaceError(with: [Deck]())
            .map { decks in
                decks.compactMap { [weak self] (deck: Deck) -> Deck? in
                    guard let date = deck.session?.date,
                          let self else { return nil }
                    
                    if date >= self.dateHandler.today {
                        return deck
                    }
                    return nil
                }
            }
            .sink { [weak self] decks in
                guard let self else { return }
                decks.forEach { deck in
                    self.notificationService.scheduleNotification(for: deck, at: self.dateHandler.today)
                }
            }
            .store(in: &cancellables)
    }
        
    func bindingToDeck(_ deck: Deck) -> Binding<Deck> {
        Binding<Deck> { [weak self] in
            guard let self = self,
                  let index = self.decks.firstIndex(where: { $0.id == deck.id }) else {
                preconditionFailure("A deck that do not exist was passed")
            }
            
            return self.decks[index]
            
        } set: { [weak self] newValue in
            guard let self = self,
                  let index = self.decks.firstIndex(where: { $0.id == newValue.id }) else {
                preconditionFailure("A deck that do not exist was passed")
            }
            
            return self.decks[index] = newValue
        }
    }
    
    func changeDetailType(for newDetailType: DetailDisplayType) {
        detailType = newDetailType
        displayCacher.saveDetailType(detailType: newDetailType)
    }
    
    private func mapDecksBySidebarSelection(decks: [Deck], selectedCollection: DeckCollection?) -> [Deck] {
        if let selectedCollection {
            return decks.filter { deck in
                deck.collectionId == selectedCollection.id
            }
        } else {
            return decks
        }
    }
    
    private func filterDecksBySearchText(_ decks: [Deck], searchText: String) -> [Deck] {
        if searchText.isEmpty {
            return decks
        } else {
            return decks.filter { $0.name.capitalized.contains(searchText.capitalized) }
        }
    }
    
    private func filterDecksForToday(_ decks: [Deck]) -> [Deck] {
        decks.filter {
            guard let session = $0.session else { return false }
            
            guard !session.cardIds.isEmpty, let isToday = try? dateHandler.isToday(date: session.date) else { return false }
            return isToday || session.date < dateHandler.today
        }
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            break
        case .failure(_):
            break
        }
    }
    
    func deleteCollection(at index: IndexSet) throws {
        let collections = self.collections
        let collectionsToDelete = index.map { i in collections[i] }
        
        try collectionsToDelete.forEach { collection in
            try deleteCollection(collection)
        }
    }
    
    func deleteCollection(_ collection: DeckCollection) throws {
        try collectionRepository.deleteCollection(collection)
    }
    
    func deleteDecks() throws {
        let decksToBeDeleted = self.decks.filter { deck in
            selection.contains(deck.id)
        }
        
        guard !decksToBeDeleted.isEmpty else {
            throw RepositoryError.couldNotDelete
        }
        
        try decksToBeDeleted
            .forEach { deck in
                try deckRepository.deleteDeck(deck)
            }
        
        selection = Set()
    }
    
    func editDeck() -> Deck? {
        guard
            selection.count == 1,
            let deck = decks.first(where: { deck in deck.id == selection.first })
        else { return nil }
        
        return deck
    }
    
    func deleteDeck(_ deck: Deck) throws {
        try deckRepository.deleteDeck(deck)
    }
    
    func didDeckPresentationStatusChanged(_ status: Bool) {
        guard status == false else {
            return
        }
        
        selection = Set()
    }
    
    func didCollectionPresentationStatusChanged(_ status: Bool) {
        guard status == false else {
            return
        }
    }
    
    func change(deck: Deck, to collection: DeckCollection?) {
        if let collection {
            try? collectionRepository.addDeck(deck, in: collection)
        } else if let collectionId = deck.collectionId, let collection = collections.first(where: { $0.id == collectionId }) {
            try? collectionRepository.removeDeck(deck, from: collection)
        }
    }
}
