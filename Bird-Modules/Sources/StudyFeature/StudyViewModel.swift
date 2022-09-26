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
    @Dependency(\.deckRepository) var deckRepository
    @Dependency(\.sessionCacher) var sessionCacher
    @Dependency(\.dateHandler) var dateHandler
    @Dependency(\.systemObserver) var systemObserver

    
    
    @Published var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    var cardsToEdit: [Card] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var shouldButtonsBeDisabled: Bool = true
    
    private lazy var timefromLastCard: Date = dateHandler.today
    
    @Published var isVOOn: Bool = getIsVOOn()
    
    init() {
    }
    
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
    
    private func sessionPublisher(cardIds: [UUID], cardSortingFunc: @MainActor @escaping (Card, Card) -> Bool) -> AnyPublisher<[Card], Never> {
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
    
    func startup(deck: Deck, cardSortingFunc: @MainActor @escaping (Card, Card) -> Bool = Woodpecker.cardSorter) {
        systemObserver.voiceOverDidChange()
            .assign(to: &$isVOOn)
            
        systemObserver.willTerminate()
            .sink {[weak self] _ in
                try? self?.saveChanges(deck: deck)
            }
            .store(in: &cancellables)

        
        displayedCardsPublisher
            .assign(to: &$displayedCards)
        
        shouldButtonsBeDisabledPublisher
            .assign(to: &$shouldButtonsBeDisabled)
        
        
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
    
    func saveChanges(deck: Deck) throws {
        
        try cardsToEdit.forEach { card in
            try deckRepository.editCard(card)
        }
        sessionCacher.setCurrentSession(session: Session(cardIds: cards.map(\.id), date: dateHandler.today, deckId: deck.id))
        
    }
    
    private func finishFetchCards(_ completion: Subscribers.Completion<RepositoryError>) {
        switch completion {
        case .finished:
            print("aiai")
        case .failure(let error):
            print(error)
        }
    }
    
    private func receiveCards(todayReviewingCards: [Card], todayLearningCards: [Card], toModify: [Card], cardSortingFunc: @MainActor @escaping (Card, Card) -> Bool) {
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
    
    private func saveCardIdsToCache(deck: Deck, ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) ) {
        let session = Session(cardIds: ids.todayReviewingCards + ids.todayLearningCards, date: dateHandler.today, deckId: deck.id)
        sessionCacher.setCurrentSession(session: session)
    }
    
    func pressedButton(for userGrade: UserGrade, deck: Deck, cardSortingFunc: @MainActor @escaping (Card, Card) -> Bool = Woodpecker.cardSorter) throws {
        guard let newCard = cards.first else { return }
        
        if newCard.woodpeckerCardInfo.isGraduated {
            try dealWithSm2Card(userGrade: userGrade)
        } else {
            try dealWithSteppedCard(userGrade: userGrade, deck: deck)
        }
        var lastCards: [Card] = []
        if cards.count > 2 {
            lastCards = cards.suffix(from: 2).sorted(by: cardSortingFunc)
        }
        
        timefromLastCard = dateHandler.today
        cards = cards.prefix(2) + lastCards
    }
    
    private func dealWithSm2Card(userGrade: UserGrade) throws {
        var newInfo: WoodpeckerCardInfo = cards[0].woodpeckerCardInfo
        
        newInfo = try Woodpecker.wpSm2(cards[0].woodpeckerCardInfo, userGrade: userGrade)
        
        
        // modifica o cards[0], salva ele em cardsToEdit, depois remove da lista de cards.
        cards[0].history.append(CardSnapshot(woodpeckerCardInfo: cards[0].woodpeckerCardInfo, userGrade: userGrade, timeSpend: dateHandler.today.timeIntervalSince1970 - timefromLastCard.timeIntervalSince1970, date: dateHandler.today))
        cards[0].woodpeckerCardInfo = newInfo
        cards[0].woodpeckerCardInfo.hasBeenPresented = true
        removeCard(shouldAddToEdit: true)
    }
    
    private func dealWithSteppedCard(userGrade: UserGrade, deck: Deck) throws {
        var newCard = cards[0]
        newCard.woodpeckerCardInfo.hasBeenPresented = true
        
        let cardDestiny = try Woodpecker.stepper(cardInfo: newCard.woodpeckerCardInfo, userGrade: userGrade, numberOfSteps: deck.spacedRepetitionConfig.numberOfSteps)
        
        switch cardDestiny {
        case .back:
            //update card and bumps to last position of the vector.
            newCard.woodpeckerCardInfo.step -= 1
            newCard.woodpeckerCardInfo.streak = 0
            removeCard()
            cards.append(newCard)
        case .stay:
            //update card and bumps to last position of the vector.
            newCard.woodpeckerCardInfo.streak = 0
            removeCard()
            cards.append(newCard)
        case .foward:
            //update card and bumps to last position of the vector.
            newCard.woodpeckerCardInfo.step += 1
            newCard.woodpeckerCardInfo.streak += 1
            removeCard()
            cards.append(newCard)
        case .graduate:
            //update card. Save it to toEdit. Remove from cards.
            cards[0].history.append(CardSnapshot(woodpeckerCardInfo: cards[0].woodpeckerCardInfo, userGrade: userGrade, timeSpend: dateHandler.today.timeIntervalSince1970 - timefromLastCard.timeIntervalSince1970, date: dateHandler.today))
            cards[0].woodpeckerCardInfo.streak += 1
            cards[0].woodpeckerCardInfo.step = 0
            cards[0].woodpeckerCardInfo.isGraduated = true
            cards[0].woodpeckerCardInfo.interval = 1
            cards[0].woodpeckerCardInfo.hasBeenPresented = true
            removeCard(shouldAddToEdit: true)
        }
        
    }
    
    private func removeCard(shouldAddToEdit: Bool = false) {
        if cards.count >= 1 {
            if shouldAddToEdit {
                cardsToEdit.append(cards[0])
            }
            cards.remove(at: 0)
        }
    }
}
