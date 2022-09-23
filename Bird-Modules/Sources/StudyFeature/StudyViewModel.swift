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

//swiftlint:disable trailing_closure
public class StudyViewModel: ObservableObject {
    private let deckRepository: DeckRepositoryProtocol
    private let sessionCacher: SessionCacher
    private let dateHandler: DateHandlerProtocol
    let deck: Deck
    let cardSortingFunc: (Card, Card) -> Bool
    
    @Published var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    var cardsToEdit: [Card] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var shouldButtonsBeDisabled: Bool = true
    
    private var timefromLastCard: Date
    
    @Published var isVOOn: Bool
    let systemObserver: SystemObserverProtocol
    
    public init(
        deckRepository: DeckRepositoryProtocol = DeckRepository.shared,
        sessionCacher: SessionCacher = SessionCacher(),
        deck: Deck,
        dateHandler: DateHandlerProtocol = DateHandler(),
        systemObserver: SystemObserverProtocol = SystemObserver(),
        isVOOn: Bool = getIsVOOn(),
        cardSortingFunc: @escaping (Card, Card) -> Bool = Woodpecker.cardSorter
    ) {
        self.deckRepository = deckRepository
        self.sessionCacher = sessionCacher
        self.deck = deck
        self.dateHandler = dateHandler
        self.cardSortingFunc = cardSortingFunc
        self.timefromLastCard = dateHandler.today
        self.isVOOn = false
        self.systemObserver = systemObserver
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
    
    private func sessionPublisher(cardIds: [UUID]) -> AnyPublisher<[Card], Never> {
        fetchCardsPublisher(for: cardIds)
            .replaceError(with: [])
            .compactMap { [weak self] cards in
                guard let self = self else {
                    return nil
                }
                return cards.sorted(by: self.cardSortingFunc)
            }
            .eraseToAnyPublisher()
    }
    
    private func newSessionCardsPublisher(cardIds: [UUID]) -> AnyPublisher<([Card], [Card], [Card]), RepositoryError> {
        print(cardIds)
        return deckRepository.fetchCardsByIds(cardIds)
            .map {
                $0.map(OrganizerCardInfo.init(card:))
            }
            .tryMap { [deck, dateHandler] cards in
                try Woodpecker.scheduler(cardsInfo: cards, config: deck.spacedRepetitionConfig, currentDate: dateHandler.today)
            }
            .handleEvents(receiveOutput: { [weak self] in self?.saveCardIdsToCache(ids: $0) })
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
    
    func startup() {
        print(deck.cardsIds)
        systemObserver.voiceOverDidChange()
            .assign(to: &$isVOOn)
            
        systemObserver.willTerminate()
            .sink {[weak self] _ in
                try? self?.saveChanges()
            }
            .store(in: &cancellables)

        
        displayedCardsPublisher
            .assign(to: &$displayedCards)
        
        shouldButtonsBeDisabledPublisher
            .assign(to: &$shouldButtonsBeDisabled)
        
        
        if let session = sessionCacher.currentSession(for: deck.id), dateHandler.isToday(date: session.date) {
            sessionPublisher(cardIds: session.cardIds)
                .assign(to: &$cards)
            
        } else {
            newSessionCardsPublisher(cardIds: deck.cardsIds)
                .sink { [weak self] in
                    self?.finishFetchCards($0)
                } receiveValue: {[weak self] cards in
                    self?.receiveCards(todayReviewingCards: cards.0, todayLearningCards: cards.1, toModify: cards.2)
                }
                .store(in: &cancellables)
        }
    }
    
    func saveChanges() throws {
        
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
    
    private func receiveCards(todayReviewingCards: [Card], todayLearningCards: [Card], toModify: [Card]) {
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
    
    private func saveCardIdsToCache(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) ) {
        let session = Session(cardIds: ids.todayReviewingCards + ids.todayLearningCards, date: dateHandler.today, deckId: deck.id)
        sessionCacher.setCurrentSession(session: session)
    }
    
    func pressedButton(for userGrade: UserGrade) throws {
        guard let newCard = cards.first else { return }
        
        if newCard.woodpeckerCardInfo.isGraduated {
            try dealWithSm2Card(userGrade: userGrade)
        } else {
            try dealWithSteppedCard(userGrade: userGrade)
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
    
    private func dealWithSteppedCard(userGrade: UserGrade) throws {
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
