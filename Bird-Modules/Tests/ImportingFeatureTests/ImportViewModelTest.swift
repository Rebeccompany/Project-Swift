//
//  ImportViewModelTest.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/10/22.
//

import XCTest
@testable import ImportingFeature
import Storage
import Habitat
import Utils
import Models

final class ImportViewModelTest: XCTestCase {
    
    var repository: DeckRepositoryMock!
    var sut: ImportViewModel!
    var dateHandler: DateHandlerMock!
    var uuidGenerator: UUIDHandlerMock!
    
    var deck: Deck!
    var cards: [Card]!

    override func setUp() {
        repository = DeckRepositoryMock()
        setupHabitatForIsolatedTesting(deckRepository: repository)
        dateHandler = DateHandlerMock()
        uuidGenerator = UUIDHandlerMock()
        sut = ImportViewModel()
        createData()
    }
    
    func createData() {
        createCards()
        createDecks()
        
        try? repository.createDeck(deck, cards: cards)
    }
    
    override func tearDown() {
        sut = nil
        dateHandler = nil
        uuidGenerator = nil
        repository = nil
        
        deck = nil
        cards = nil
    }

    func testSaveNewCards() throws {
        let cards = try DeckConverter()
            .convert(DummyCSVData.dummyData.first!)
            .map {
                ImportedCardInfoTransformer.transformToCard($0, deckID: deck.id, cardColor: .red, dateHandler: dateHandler, uuidHandler: uuidGenerator)!
            }

        let cardsInitialCount = (repository.data[deck.id]?.deck.cardCount)!

        sut.save(cards, to: repository.data[deck.id]!.deck)

        XCTAssertEqual(cards.count, repository.data[deck.id]!.deck.cardCount - cardsInitialCount)
    }
    
    func createCards() {
        cards = []
        var i = 0
        while i < 7 {
            cards.append(createNewCard(state: .learn))
            i += 1
        }
        
        i = 0
        while i < 5 {
            cards.append(createNewCard(state: .review))
            i += 1
        }
    }
    
    func createNewCard(state: WoodpeckerState) -> Card {
        Card(id: UUID(),
             front: NSAttributedString(string: "front"),
             back: NSAttributedString(string: "back"),
             color: CollectionColor.red,
             datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                 lastEdit: Date(timeIntervalSince1970: 0),
                                 createdAt: Date(timeIntervalSince1970: 0)),
             deckID: UUID(),
             woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                    isGraduated: state == .review ? true : false,
                                                    easeFactor: 2.5, streak: 0,
                                                    interval: state == .review ? 1 : 0,
                                                    hasBeenPresented: state == .review ? true : false),
             history: state == .review ? [CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(step: 0,
                                                                                              isGraduated: false,
                                                                                              easeFactor: 2.5,
                                                                                              streak: 0,
                                                                                              interval: 0,
                                                                                              hasBeenPresented: false),
                                                       userGrade: .correct,
                                                       timeSpend: 20,
                                                       date: Date(timeIntervalSince1970: -86400))] : [])
        
    }
    
    func createDecks() {
        deck = newDeck()
    }
    
    func newDeck() -> Deck {
        Deck(id: UUID(),
             name: "Deck0",
             icon: IconNames.abc.rawValue,
             color: CollectionColor.red,
             datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                 lastEdit: Date(timeIntervalSince1970: 0),
                                 createdAt: Date(timeIntervalSince1970: 0)),
             collectionId: nil,
             cardsIds: [],
             spacedRepetitionConfig: .init(maxLearningCards: 20, maxReviewingCards: 200, numberOfSteps: 4),
             category: DeckCategory.arts,
             storeId: nil)
    }
    
    enum WoodpeckerState {
        case review, learn
    }

}
