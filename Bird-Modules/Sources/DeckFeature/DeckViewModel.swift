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
    
    func deckListener(_ deck: Deck) -> AnyPublisher<Deck, RepositoryError> {
        deckRepository
            .cardListener(forId: deck.id)
            .flatMap {[weak self, deck] _ in
                guard let self = self else {
                    return Fail<Deck, RepositoryError>(error: .errorOnListening).eraseToAnyPublisher()
                }
                
                return self.deckRepository.fetchDeckById(deck.id)
            }
            .eraseToAnyPublisher()
    }
    
    func startup(_ deck: Deck) {
        cardListener(deck)
            .assign(to: &$cards)
        
        var deck = deck
        deck.datesLogs.lastAccess = dateHandler.today
        try? deckRepository.editDeck(deck)
    }
    
    func checkIfCanStudy(_ deck: Deck) -> Bool {
        do {
            if let session = deck.session, dateHandler.isToday(date: session.date) {
                return !session.cardIds.isEmpty
            }
            
            let cardsInfo = cards.map { OrganizerCardInfo(card: $0) }
            let cardsToStudy = try Woodpecker.scheduler(cardsInfo: cardsInfo, config: deck.spacedRepetitionConfig)
            let todayCards = cardsToStudy.todayLearningCards + cardsToStudy.todayReviewingCards
            if !todayCards.isEmpty {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
        
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
    
    #warning("Testes unitarios dessa função")
    func publishDeck(_ deck: Deck) {
        loadingPhase = .loading
        
        externalDeckService.uploadNewDeck(deck, with: cards)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingPhase = .showSuccess
                case .failure(let error):
                    self?.loadingPhase = .showFailure
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] storeId in
                print("store id \(storeId)")
                var deckWithStoreId = deck
                deckWithStoreId.storeId = storeId
                try? self?.deckRepository.editDeck(deckWithStoreId)
            }
            .store(in: &cancellables)
    }
    
    #warning("Testes unitarios dessa função")
    func deletePublicDeck(_ deck: Deck) {
        loadingPhase = .loading
        
        externalDeckService.deleteDeck(deck)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.loadingPhase = .showSuccess
                case .failure(let error):
                    self?.loadingPhase = .showFailure
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] _ in
                var deckWithStoreId = deck
                deckWithStoreId.storeId = nil
                try? self?.deckRepository.editDeck(deckWithStoreId)
            }
            .store(in: &cancellables)
    }
    
}
