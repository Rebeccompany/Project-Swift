//
//  File.swift
//  
//
//  Created by Marcos Chevis on 05/09/22.
//

import Foundation
import Storage
import Models
import Woodpecker
import Combine
import Utils
import Habitat

//swiftlint:disable trailing_closure

public class StudyViewModel: ObservableObject {
    
    // MARK: Dependencies
    @Dependency(\.deckRepository) var deckRepository
    @Dependency(\.sessionCacher) var sessionCacher
    @Dependency(\.dateHandler) var dateHandler
    @Dependency(\.systemObserver) var systemObserver
    
    // MARK: Logic Vars
    @Published var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    var cardsToEdit: [Card] = []
    
    private lazy var timefromLastCard: Date = dateHandler.today
    
    // MARK: Flags
    @Published var shouldButtonsBeDisabled: Bool = true
    @Published var isVOOn: Bool = getIsVOOn()
    
    // MARK: Combine Vars
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var displayedCardsPublisher: AnyPublisher<[CardViewModel], Never> {
        $cards.map { cards -> [Card] in
            Array(cards.prefix(2).reversed())
        }
        .map { cards in
            cards.map(CardViewModel.init)
        }
        .eraseToAnyPublisher()
    }
    
    private var shouldButtonsBeDisabledPublisher: AnyPublisher<Bool, Never> {
        $displayedCards.map { cards in
            !(cards.last?.isFlipped ?? true)
        }
        .eraseToAnyPublisher()
    }
    
    private func sessionPublisher(cardIds: [UUID], cardSortingFunc: @escaping (Card, Card) -> Bool) -> AnyPublisher<[Card], Never> {
        fetchCardsPublisher(for: cardIds)
            .replaceError(with: [])
            .compactMap { cards in
                cards.sorted(by: cardSortingFunc)
            }
            .eraseToAnyPublisher()
    }
    
    private func newSessionCardsPublisher(deck: Deck, cardIds: [UUID]) -> AnyPublisher<([Card], [Card], [Card]), RepositoryError> {
        deckRepository.fetchCardsByIds(cardIds)
            .map {
                $0.map(OrganizerCardInfo.init(card:))
            }
            .tryMap { [dateHandler] cards in
                try Woodpecker.scheduler(cardsInfo: cards, config: deck.spacedRepetitionConfig, currentDate: dateHandler.today)
            }
            .handleEvents(receiveOutput: { [weak self] in self?.saveCardIdsToCache(deck: deck, ids: $0) })
            .mapError { _ in
                RepositoryError.internalError
            }
            .flatMap { [weak self] in
                guard let self = self else {
                    return Fail<([Card], [Card], [Card]), RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
                }
                
                return self.transformIdsIntoPublishers(ids: $0)
            }
            .eraseToAnyPublisher()
    }
    
    init() {
    }
    
    // MARK: - Startup
    func startup(deck: Deck, mode: StudyMode, cardSortingFunc: @escaping (Card, Card) -> Bool = Woodpecker.cardSorter) {
        systemObserver.voiceOverDidChange()
            .assign(to: &$isVOOn)
        
        systemObserver.willTerminate()
            .sink {[weak self] _ in
                try? self?.saveChanges(deck: deck, mode: mode)
            }
            .store(in: &cancellables)
        
        displayedCardsPublisher
            .assign(to: &$displayedCards)
        
        shouldButtonsBeDisabledPublisher
            .assign(to: &$shouldButtonsBeDisabled)
        
        if mode == .spaced {
            startupForSpaced(deck: deck, cardSortingFunc: cardSortingFunc)
        } else {
            startupForCramming(deck: deck, cardSortingFunc: cardSortingFunc)
        }
    }
    
    private func startupForCramming(deck: Deck, cardSortingFunc: @escaping (Card, Card) -> Bool) {
        deckRepository
            .fetchCardsByIds(deck.cardsIds)
            .map { cards in
                cards.map { card in
                    var card = card
                    card.woodpeckerCardInfo = WoodpeckerCardInfo(hasBeenPresented: false)
                    return card
                }
                .sorted(by: cardSortingFunc)
            }
            .replaceError(with: [])
            .assign(to: &$cards)
    }
    
    private func startupForSpaced(deck: Deck, cardSortingFunc: @escaping (Card, Card) -> Bool) {
        if let session = sessionCacher.currentSession(for: deck.id), dateHandler.isToday(date: session.date) {
            sessionPublisher(cardIds: session.cardIds, cardSortingFunc: cardSortingFunc)
                .assign(to: &$cards)
            
        } else {
            newSessionCardsPublisher(deck: deck, cardIds: deck.cardsIds)
                .sink { [weak self] in
                    self?.finishFetchCards($0)
                } receiveValue: { [weak self] cards in
                    self?.receiveCards(todayReviewingCards: cards.0, todayLearningCards: cards.1, toModify: cards.2, cardSortingFunc: cardSortingFunc)
                }
                .store(in: &cancellables)
        }
    }
    
    private func finishFetchCards(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            print("aiai")
        case .failure(let error):
            print(error)
        }
    }
    
    private func receiveCards(todayReviewingCards: [Card], todayLearningCards: [Card], toModify: [Card], cardSortingFunc: @escaping (Card, Card) -> Bool) {
        cards = (todayLearningCards + todayReviewingCards).sorted(by: cardSortingFunc)
        cardsToEdit = toModify.map { card in
            var newCard = card
            newCard.dueDate = dateHandler.dayAfterToday(1)
            return newCard
        }
    }
    
    private func transformIdsIntoPublishers(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID])) -> AnyPublisher<([Card], [Card], [Card]), RepositoryError> {
        
        
        Publishers.CombineLatest3(fetchCardsPublisher(for: ids.todayLearningCards),
                                  fetchCardsPublisher(for: ids.todayReviewingCards),
                                  fetchCardsPublisher(for: ids.toModify))
        .eraseToAnyPublisher()
    }
    
    private func fetchCardsPublisher(for ids: [UUID]) -> AnyPublisher<[Card], RepositoryError> {
        if ids.isEmpty {
            return Just<[Card]>([]).setFailureType(to: RepositoryError.self).eraseToAnyPublisher()
        } else {
            return deckRepository.fetchCardsByIds(ids)
        }
    }
    
    // MARK: - Persistence
    func saveChanges(deck: Deck, mode: StudyMode) throws {
        
        guard mode == .spaced else { return }
        
        try cardsToEdit.forEach { card in
            try deckRepository.editCard(card)
        }
        sessionCacher.setCurrentSession(session: Session(cardIds: cards.map(\.id), date: dateHandler.today, deckId: deck.id))
        
    }
    
    private func saveCardIdsToCache(deck: Deck, ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) ) {
        let session = Session(cardIds: ids.todayReviewingCards + ids.todayLearningCards, date: dateHandler.today, deckId: deck.id)
        sessionCacher.setCurrentSession(session: session)
    }
    
    // MARK: - Study Logic
    func pressedButton(for userGrade: UserGrade, deck: Deck, mode: StudyMode, cardSortingFunc: @escaping (Card, Card) -> Bool = Woodpecker.cardSorter) throws {
        
        if mode == .spaced {
            try spacedFlow(userGrade: userGrade, deck: deck)
        } else {
            try crammingFlow(userGrade: userGrade, numberOfSteps: deck.spacedRepetitionConfig.numberOfSteps)
        }
        
        var lastCards: [Card] = []
        if cards.count > 2 {
            lastCards = cards.suffix(from: 2).sorted(by: cardSortingFunc)
        }
        
        timefromLastCard = dateHandler.today
        cards = cards.prefix(2) + lastCards
        
    }
    
    private func crammingFlow(userGrade: UserGrade, numberOfSteps: Int) throws {
        guard var newCard = cards.first else { return }
        let destiny = try Woodpecker.stepper(cardInfo: newCard.woodpeckerCardInfo, userGrade: userGrade, numberOfSteps: numberOfSteps)
        
        switch destiny {
        case .back:
            newCard.woodpeckerCardInfo.step -= 1
        case .stay:
            break
        case .foward:
            newCard.woodpeckerCardInfo.step += 1
        case .graduate:
            newCard.woodpeckerCardInfo.step = numberOfSteps - 1
        }
        
        removeCard()
        cards.append(newCard)
    }
    
    private func spacedFlow(userGrade: UserGrade, deck: Deck) throws {
        guard let newCard = cards.first else { return }
        
        if newCard.woodpeckerCardInfo.isGraduated {
            try dealWithSm2Card(userGrade: userGrade)
        } else {
            try dealWithSteppedCard(userGrade: userGrade, deck: deck)
        }
    }
    
    private func dealWithSm2Card(userGrade: UserGrade) throws {
        guard var card = cards.first else { return }
        let newInfo = try Woodpecker.wpSm2(card.woodpeckerCardInfo, userGrade: userGrade)
        
        // modifica o cards[0], salva ele em cardsToEdit, depois remove da lista de cards.
        card.history.append(CardSnapshot(woodpeckerCardInfo: card.woodpeckerCardInfo, userGrade: userGrade, timeSpend: dateHandler.today.timeIntervalSince1970 - timefromLastCard.timeIntervalSince1970, date: dateHandler.today))
        card.woodpeckerCardInfo = newInfo
        card.woodpeckerCardInfo.hasBeenPresented = true
        
        removeCard()
        cardsToEdit.append(card)
    }
    
    private func dealWithSteppedCard(userGrade: UserGrade, deck: Deck) throws {
        guard var card = cards.first else { return }
        card = try Woodpecker.dealWithLearningCard(card: card, userGrade: userGrade, numberOfSteps: deck.spacedRepetitionConfig.numberOfSteps, timefromLastCard: timefromLastCard, dateHandler: dateHandler)
        
        if userGrade == .correctEasy {
            removeCard()
            cardsToEdit.append(card)
        } else {
            removeCard()
            cards.append(card)
        }
    }
    
    private func removeCard() {
        if cards.count >= 1 {
            cards.remove(at: 0)
        }
    }
}
