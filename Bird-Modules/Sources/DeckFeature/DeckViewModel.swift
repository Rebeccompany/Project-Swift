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
            return cards.filter { $0.front.string.contains(searchFieldContent) || $0.back.string.contains(searchFieldContent) }
        }
    }
    
    func publishDeck(_ deck: Deck) {
        loadingPhase = .loading
        
        externalDeckService.uploadNewDeck(deck, with: cards)
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
    
}
