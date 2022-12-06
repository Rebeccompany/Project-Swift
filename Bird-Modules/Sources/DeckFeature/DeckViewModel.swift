//
//  DeckViewModel.swift
//  
//
//  Created by Caroline Taus on 13/09/22.
//

import Foundation
import Models
import HummingBird
import Combine
import Puffins
import Storage
import Woodpecker
import Utils
import Habitat

enum LoadingPhase: Equatable {
    case loading
    case showSuccess
    case showFailure
}

@MainActor
public class DeckViewModel: ObservableObject {
    @Published var searchFieldContent: String
    @Published var cards: [Card]
    @Published var loadingPhase: LoadingPhase?
    
    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    @Dependency(\.externalDeckService) private var externalDeckService: ExternalDeckServiceProtocol
    
    public init() {
        self.searchFieldContent = ""
        self.cards = []
        self.loadingPhase = nil
    }
    
    private func cardListener(_ deck: Deck) -> AnyPublisher<[Card], Never> {
        deckRepository
            .cardListener(forId: deck.id)
            .replaceError(with: [])
            .map { cards in cards.sorted { c1, c2 in c1.datesLogs.createdAt > c2.datesLogs.createdAt } }
            .eraseToAnyPublisher()
    }
    
    func startup(_ deck: Deck) {
        cardListener(deck)
            .sink { [weak self] cards in self?.cards = cards }
            .store(in: &cancellables)
        
        var deck = deck
        deck.datesLogs.lastAccess = dateHandler.today
        try? deckRepository.editDeck(deck)
    }
    
    func tearDown() {
        cancellables
            .forEach { $0.cancel() }
    }
    
    func checkIfCanStudy(_ deck: Deck) -> Bool {
        if cards.isEmpty { return false }
        guard let session = deck.session else { return true }
        guard !session.cardIds.isEmpty,
            let isToday = try? dateHandler.isToday(date: session.date)
        else { return false }
        
        return isToday || session.date < dateHandler.today
    }
    
    func deleteFlashcard(card: Card) throws {
        try deckRepository.deleteCard(card)
    }
    
    var cardsSearched: [Card] {
        if searchFieldContent.isEmpty {
            return cards
        } else {
            return cards.filter { $0.front.string.capitalized.contains(searchFieldContent.capitalized) || $0.back.string.capitalized.contains(searchFieldContent.capitalized) }
        }
    }
    
    func publishDeck(_ deck: Deck, user: User) {
        loadingPhase = .loading
        
        externalDeckService.uploadNewDeck(deck, with: cards, owner: user)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingPhase = .showSuccess
                case .failure(_):
                    self?.loadingPhase = .showFailure
                }
            } receiveValue: { [weak self] storeId in
                var deckWithStoreId = deck
                deckWithStoreId.storeId = storeId
                deckWithStoreId.ownerId = user.appleIdentifier
                try? self?.deckRepository.editDeck(deckWithStoreId)
            }
            .store(in: &cancellables)
    }
    
    func deletePublicDeck(_ deck: Deck) {
        loadingPhase = .loading
        
        externalDeckService.deleteDeck(deck)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingPhase = .showSuccess
                case .failure(_):
                    self?.loadingPhase = .showFailure
                }
            } receiveValue: { [weak self] _ in
                var deckWithStoreId = deck
                deckWithStoreId.storeId = nil
                try? self?.deckRepository.editDeck(deckWithStoreId)
            }
            .store(in: &cancellables)
    }
    
    func updatePublicDeck(_ deck: Deck, user: User) {
        loadingPhase = .loading
        
        externalDeckService.updateADeck(deck, with: cards, owner: user)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingPhase = .showSuccess
                case .failure(_):
                    self?.loadingPhase = .showFailure
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
    
    /**
        In order to publish a Deck is necessary that the storeId is nil, meaning there is no deck on the store.
     */
    func isPublishButtonDisabled(for deck: Deck) -> Bool {
        deck.storeId != nil
    }
    
    /**
        In order to update a Deck is necessary that the storeId is not nil and the user id of the app user is equal to the deck owner
        this is necessarry in order to block update from users other than the owners
     */
    func isUpdateButtonDisabled(for deck: Deck, user: User) -> Bool {
        (deck.storeId == nil) || (deck.ownerId != user.appleIdentifier)
    }
    
    /**
        In order to share a Deck is necessary that the storeId is nil, meaning there is no deck on the store.
     */
    func isShareButtonDisabled(for deck: Deck) -> Bool {
        (deck.storeId == nil)
    }
    
    /**
        In order to update a Deck is necessary that the storeId is not nil and the user id of the app user is equal to the deck owner
        this is necessarry in order to block update from users other than the owners
     */
    func isDeleteButtonDisabled(for deck: Deck, user: User) -> Bool {
        (deck.storeId == nil) || (deck.ownerId != user.appleIdentifier)
    }
    
}
