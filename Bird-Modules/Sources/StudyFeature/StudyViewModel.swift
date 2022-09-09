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

public class StudyViewModel: ObservableObject {
    private let deckRepository: DeckRepositoryProtocol
    private let sessionCacher: SessionCacher
    private let dateHandler: DateHandlerProtocol
    let deck: Deck
    
    @Published private var cards: [Card] = []
    @Published var displayedCards: [CardViewModel] = []
    private var cardsToEdit: [Card] = []
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var shouldButtonsBeDisabled: Bool = true
    
    public init(
        deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil),
        sessionCacher: SessionCacher = SessionCacher(),
        deck: Deck,
        dateHandler: DateHandlerProtocol = DateHandler()
    ) {
        self.deckRepository = deckRepository
        self.sessionCacher = sessionCacher
        self.deck = deck
        self.dateHandler = dateHandler
    }
    
    func startup() {
        
        $cards.map { cards -> [Card] in
            Array(cards.prefix(2).reversed())
        }
        .map { cards in
            cards.map(CardViewModel.init)
        }
        .assign(to: &$displayedCards)
        
        $displayedCards.map { cards in
            !(cards.last?.isFlipped ?? true)
        }
        .assign(to: &$shouldButtonsBeDisabled)
        
        
        if let session = sessionCacher.currentSession(for: deck.id), dateHandler.isToday(date: session.date) {
            deckRepository.fetchCardsByIds(session.cardIds)
                .replaceError(with: [])
                .assign(to: &$cards)
            
        } else {
            deckRepository.fetchCardsByIds(deck.cardsIds)
                .map { $0.map(OrganizerCardInfo.init(card:)) }
                .tryMap { [deck, dateHandler] cards in
                    try Woodpecker.scheduler(cardsInfo: cards, config: deck.spacedRepetitionConfig, currentDate: dateHandler.today)
                }
                .handleEvents(receiveOutput: saveCardIdsToCache)
                .mapError {_ in
                    RepositoryError.internalError
                }
                .flatMap(transformIdsIntoPublishers)
                .sink(receiveCompletion: finishFetchCards, receiveValue: receiveCards)
                .store(in: &cancellables)
        }
    }
    private func finishFetchCards(_ completion: Subscribers.Completion<RepositoryError>) {
        
    }
    
    private func receiveCards(todayReviewingCards: [Card], todayLearningCards: [Card], toModify: [Card]) {
        cards = todayLearningCards + todayReviewingCards
    }
    
    private func transformIdsIntoPublishers(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID])) -> AnyPublisher<([Card], [Card], [Card]), RepositoryError> {
        Publishers.CombineLatest3(deckRepository.fetchCardsByIds(ids.todayLearningCards),
                                  deckRepository.fetchCardsByIds(ids.todayReviewingCards),
                                  deckRepository.fetchCardsByIds(ids.toModify))
        .eraseToAnyPublisher()
        
        
    }
    
    private func saveCardIdsToCache(ids: (todayReviewingCards: [UUID], todayLearningCards: [UUID], toModify: [UUID]) ) {
        let session = Session(cardIds: ids.todayReviewingCards + ids.todayLearningCards, date: dateHandler.today, deckId: deck.id)
        sessionCacher.setCurrentSession(session: session)
    }
    
    func pressedButton(for userGrade: UserGrade) {
        guard let card = cards.first else { return }
        var newCard = card
        
        if card.woodpeckerCardInfo.isGraduated {
            var newInfo: WoodpeckerCardInfo = card.woodpeckerCardInfo
            do {
                newInfo = try Woodpecker.wpSm2(card.woodpeckerCardInfo, userGrade: userGrade)
            } catch {
                print("FODEU3")
            }
            
            newCard.woodpeckerCardInfo = newInfo
            
            if cards.count >= 1 {
                cardsToEdit.append(cards[0])
                cards.remove(at: 0)
            }
            
        } else {
            let cardDestiny: CardDestiny
            
            do {
                #warning("number of steps tem qu ser guardado em spacedRepConfig em deck")
                cardDestiny =  try Woodpecker.stepper(cardInfo: card.woodpeckerCardInfo, userGrade: userGrade, numberOfSteps: 3)
            } catch {
                print("FODEU")
                return
            }
            
            switch cardDestiny {
            case .back:
                print("back")
                newCard.woodpeckerCardInfo.step -= 1
                if cards.count >= 1 {
                    cards.remove(at: 0)
                }
                cards.append(newCard)
                //move card to new position
            case .stay:
                print("fica")
                if cards.count >= 1 {
                    cards.remove(at: 0)
                }
                cards.append(newCard)
                //move card to new position
            case .foward:
                print("frnte")
                newCard.woodpeckerCardInfo.step += 1
                if cards.count >= 1 {
                    cards.remove(at: 0)
                }
                cards.append(newCard)
                //move card to new position
            case .graduate:
                print("gradua")
                newCard.woodpeckerCardInfo.step = 0
                newCard.woodpeckerCardInfo.isGraduated = true
                
                if cards.count >= 1 {
                    cardsToEdit.append(cards[0])
                    cards.remove(at: 0)
                }
            }
        }
        print(cards.count)
    }
}
