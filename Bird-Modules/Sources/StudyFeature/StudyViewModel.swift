//
//  StudyViewModel.swift
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
import SwiftUI

//swiftlint:disable trailing_closure

public class StudyViewModel: ObservableObject {
    
    // MARK: Dependencies
    @Dependency(\.deckRepository) var deckRepository
    @Dependency(\.dateHandler) var dateHandler
    @Dependency(\.systemObserver) var systemObserver
    @Dependency(\.uuidGenerator) var uuidGenerator
    
    // MARK: Logic Vars
    @Published var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    var cardsToEdit: [Card] = []
    
    private lazy var timefromLastCard: Date = dateHandler.today
    
    // MARK: Flags
    @Published var shouldButtonsBeDisabled: Bool = true
    @Published var isVOOn: Bool = getIsVOOn()
    @Published var shouldDismiss: Bool = false
    
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
            .handleEvents(receiveOutput: { [weak self] ids in
                try? self?.saveCardIdsToCache(deck: deck, ids: ids)
            })
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
    
    private func saveCardIdsToCache(deck: Deck, ids: SchedulerResponse) throws {
        try deckRepository.createSession(Session(cardIds: ids.todayReviewingCards + ids.todayLearningCards, date: dateHandler.today, deckId: deck.id, id: uuidGenerator.newId()), for: deck)
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
        if let session = deck.session, let isToday = try? dateHandler.isToday(date: session.date), isToday {
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
        
        #if os(macOS)
//        NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)
//            .sink { [weak self] _ in
//                try? self?.saveChanges(deck: deck, mode: .spaced)
//            }
//            .store(in: &cancellables)
        #endif
    }
    
    private func finishFetchCards(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            break
        case .failure(_):
            break
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
    
    private func transformIdsIntoPublishers(ids: SchedulerResponse) -> AnyPublisher<([Card], [Card], [Card]), RepositoryError> {
        Publishers.CombineLatest3(fetchCardsPublisher(for: ids.todayLearningCards),
                                  fetchCardsPublisher(for: ids.todayReviewingCards),
                                  fetchCardsPublisher(for: ids.toModify))
        .eraseToAnyPublisher()
    }
    
    private func transformIdsIntoPublishersWithDate(ids: SchedulerResponse, date: Date) -> AnyPublisher<([Card], [Card], [Card], Date), RepositoryError> {
        Publishers.CombineLatest4(fetchCardsPublisher(for: ids.todayLearningCards),
                                  fetchCardsPublisher(for: ids.todayReviewingCards),
                                  fetchCardsPublisher(for: ids.toModify),
                                  Just(date).setFailureType(to: RepositoryError.self))
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
            
            guard let lastSnapshot = card.history.max(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 }) else { return }

            try deckRepository.addHistory(lastSnapshot, to: card)
        }
        
        try saveToCache(deck: deck, ids: cards.map(\.id))
    }
    
    private func saveToCache(deck: Deck, ids: [UUID], cardSortingFunc: @escaping (Card, Card) -> Bool = Woodpecker.cardSorter) throws {
        var isFirstSession: Bool = true
        if let session = deck.session {
            try deckRepository.deleteSession(session, for: deck)
            isFirstSession = false
        }
        
        if ids.isEmpty {
            handleWhenStudySessionIsOver(deck: deck, cardSortingFunc: cardSortingFunc)
        } else {
            try deckRepository.createSession(Session(cardIds: ids, date: dateHandler.today, deckId: deck.id, id: uuidGenerator.newId()), for: deck)
            if !isFirstSession {
                shouldDismiss = true
            }
        }
    }
    
    private func handleWhenStudySessionIsOver(deck: Deck, cardSortingFunc: @escaping (Card, Card) -> Bool) {
        deckRepository.fetchCardsByIds(deck.cardsIds)
            .map {
                $0.map(OrganizerCardInfo.init(card:))
            }
            .tryMap {[weak self] (cards: [OrganizerCardInfo]) in
                guard let self else { throw RepositoryError.internalError }
                return try self.getSchedule(deck: deck, cards: cards)
            }
            .mapError { _ in
                RepositoryError.internalError
            }
            .flatMap { [weak self] (date: Date, scheduledCardsIds: SchedulerResponse) in
                guard let self = self else {
                    return Fail<([Card], [Card], [Card], Date), RepositoryError>(error: .failedFetching).eraseToAnyPublisher()
                }
                
                return self.transformIdsIntoPublishersWithDate(ids: scheduledCardsIds, date: date)
                
            }
            .sink { [ weak self ] completion in
                switch completion {
                case .finished:
                    self?.shouldDismiss = true
                case .failure(_):
                    break
                }
                
            } receiveValue: { [weak self] (data: ([Card], [Card], [Card], Date)) in

                guard let self = self else { return }
                self.editCardsToModify(cards: data.2, date: data.3)
                
                try? self.createNewSessionAtEndOfStudy(deck: deck, cards: data.0 + data.1, date: data.3, cardSortingFunc: cardSortingFunc)
                
            }
            .store(in: &cancellables)
    }
    
    private func getSchedule(deck: Deck, cards: [OrganizerCardInfo]) throws -> (Date, SchedulerResponse) {
        let date = cards.compactMap(\.dueDate).min() ?? dateHandler.dayAfterToday(1)
        let scheduledCardsIds = try Woodpecker.scheduler(cardsInfo: cards, config: deck.spacedRepetitionConfig, currentDate: date)
        return (date, scheduledCardsIds)
    }
    
    private func editCardsToModify(cards: [Card], date: Date) {
        let cardsToEdit = cards.map { card in
            var newCard = card
            newCard.dueDate = date.addingTimeInterval(86400)
            return newCard
        }
        cardsToEdit.forEach { card in
            try? self.deckRepository.editCard(card)
        }
    }
    
    private func createNewSessionAtEndOfStudy(deck: Deck, cards: [Card], date: Date, cardSortingFunc: @escaping (Card, Card) -> Bool) throws {
        let cards = (cards).sorted(by: cardSortingFunc)
        try self.deckRepository.createSession(Session(cardIds: cards.map(\.id), date: date, deckId: deck.id, id: self.uuidGenerator.newId()), for: deck)
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
            cardsToEdit.append(newCard)
            removeCard()
            return
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
    
    // MARK: - Study Progress
    func getSessionTotalCards() -> Int {
        cards.count + cardsToEdit.count
    }
    
    func getSessionTotalSeenCards() -> Int {
        cardsToEdit.count
    }
    
    func getSessionReviewingCards(mode: StudyMode) -> Int {
        guard mode == .spaced else { return 0 }
        
        let graduatedCardCount = cards.filter { $0.woodpeckerCardInfo.isGraduated }.count
        let cardsToEditCount = cardsToEdit.filter { $0.history.last?.woodpeckerCardInfo.isGraduated ?? false }.count
        return graduatedCardCount + cardsToEditCount
    }
    
    func getSessionReviewingSeenCards(mode: StudyMode) -> Int {
        guard mode == .spaced else { return 0 }
        
        return cardsToEdit.filter { $0.history.last?.woodpeckerCardInfo.isGraduated ?? false }.count
    }
    
    func getSessionLearningCards(mode: StudyMode) -> Int {
        guard mode == .spaced else { return 0 }
        
        let notGraduatedCardCount = cards.filter { !$0.woodpeckerCardInfo.isGraduated }.count
        let cardsToEditCount = cardsToEdit.filter { !($0.history.last?.woodpeckerCardInfo.isGraduated ?? true) }.count
        return notGraduatedCardCount + cardsToEditCount
    }
    
    func getSessionLearningSeenCards(mode: StudyMode) -> Int {
        guard mode == .spaced else { return 0 }
        return cardsToEdit.filter { !($0.history.last?.woodpeckerCardInfo.isGraduated ?? true) }.count
    }
    
}
