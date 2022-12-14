
//
//  ContentViewModelTests.swift
//
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/22.
//

import XCTest
@testable import AppFeature
import Models
import Storage
import Habitat
import Combine
import Tweet
import Utils


final class ContentViewModelTests: XCTestCase {
    
    var sut: ContentViewModel!
    var deckRepositoryMock: DeckRepositoryMock!
    var displayCacherMock: DisplayCacher!
    var localStorageMock: LocalStorageMock!
    var collectionRepositoryMock: CollectionRepositoryMock!
    var userNotificationService: UserNotificationServiceMock!
    var notificationService: NotificationService!
    var dateHandler: DateHandlerMock!
    var notificationCenter: NotificationCenterMock!
    var cancelables: Set<AnyCancellable>!
    var deck0: Deck!
    var deck1: Deck!
    var deck2: Deck!
    var deck3: Deck!
    var cards: [Card]!
    
    override func setUp() {
        deckRepositoryMock = DeckRepositoryMock()
        collectionRepositoryMock = CollectionRepositoryMock()
        localStorageMock = LocalStorageMock()
        displayCacherMock = DisplayCacher(localStorage: localStorageMock)
        userNotificationService = UserNotificationServiceMock()
        dateHandler = DateHandlerMock()
        notificationService = NotificationService(center: userNotificationService)
        notificationCenter = NotificationCenterMock()
        
        setupHabitatForIsolatedTesting(deckRepository: deckRepositoryMock, collectionRepository: collectionRepositoryMock, displayCacher: displayCacherMock, notificationService: notificationService, notificationCenter: notificationCenter)
        sut = ContentViewModel()
        cancelables = Set<AnyCancellable>()
        createData()
    }
    
    func createData() {
        createCards()
        createDecks()
        
        try? deckRepositoryMock.createDeck(deck0, cards: cards)
        try? deckRepositoryMock.createDeck(deck1, cards: [])
        try? deckRepositoryMock.createDeck(deck2, cards: [])
        try? deckRepositoryMock.createDeck(deck3, cards: [])
    }
    
    override func tearDown() {
        cancelables.forEach { cancellable in
            cancellable.cancel()
        }
        
        sut = nil
        collectionRepositoryMock = nil
        deckRepositoryMock = nil
        cancelables = nil
        dateHandler = nil
        notificationService = nil
        userNotificationService = nil
        notificationCenter = nil
        localStorageMock = nil
        displayCacherMock = nil
        
        deck0 = nil
        deck1 = nil
        deck2 = nil
        deck3 = nil
        
        cards = nil
    }
    
    func testStartup() {
        let collectionExpectation = expectation(description: "Connection with collection repository")
        let deckExpectation = expectation(description: "Connection with Deck repository")
        
        var collectionCount = 0
        var decksCount = 0
        
        sut.startup()
        sut.$collections
            .sink {[unowned self] collections in
                if collectionCount > 0 {
                    XCTAssertEqual(collections, collectionRepositoryMock.collections)
                    collectionExpectation.fulfill()
                } else {
                    collectionCount += 1
                }
            }
            .store(in: &cancelables)
        
        sut.$decks
            .sink { [unowned self] decks in
                if decksCount > 0 {
                    XCTAssertEqual(decks, self.deckRepositoryMock.data.map(\.value.deck))
                    XCTAssertEqual(self.sut.selectedCollection, nil)
                    deckExpectation.fulfill()
                } else {
                    decksCount += 1
                }
            }
            .store(in: &cancelables)
        
        wait(for: [collectionExpectation, deckExpectation], timeout: 1)
    }
    
    func testStartupDetail() {
        displayCacherMock.saveDetailType(detailType: .table)
        XCTAssertEqual(sut.detailType, .grid)
        
        sut.startup()
        
        XCTAssertEqual(.table, sut.detailType)
    }
    
    func testDeckBindingGet() {
        var deck: Deck?
        
        sut.decks = self.deckRepositoryMock.data.map(\.value.deck)
        
        deckRepositoryMock
            .fetchDeckById(deck0.id)
            .sink { completion in
                print("aiai")
            } receiveValue: { decko in
                deck = decko
            }
            .store(in: &cancelables)
        sut.startup()
        
        let binding = sut.bindingToDeck(deck!)
        
        XCTAssertEqual(deck, binding.wrappedValue)
    }
    
    func testDeckBindingSet() {
        sut.startup()
        sut.decks = self.deckRepositoryMock.data.map(\.value.deck)
        let binding = sut.bindingToDeck(deck0)
        
        let newName = "Alterado"
        binding.wrappedValue.name = newName
        let index = sut.decks.firstIndex(where: { deck0.id == $0.id})
        
        XCTAssertEqual(sut.decks[index!].name, newName)
    }
    
    func testDeckReactionToSidebarSelection() throws {
        
        var deck1 = deck1
        deck1?.collectionId = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!
        var deck2 = deck2
        deck2?.collectionId = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!
        
        try deckRepositoryMock.editDeck(deck1!)
        try deckRepositoryMock.editDeck(deck2!)
        
        sut.startup()
        sut.collections = collectionRepositoryMock.collections
        sut.decks = deckRepositoryMock.data.map(\.value.deck)
        sut.selectedCollection = collectionRepositoryMock.collections[0]
        
        XCTAssertEqual(Array([deck1!, deck2!]).sorted { $0.id.uuidString > $1.id.uuidString }, sut.filteredDecks.sorted { $0.id.uuidString > $1.id.uuidString })
        
    }
    
    func testAllDecksFilteredBySearchText() {
        
        deckRepositoryMock.data[deck0.id]!.deck.name = "Swift"
        try? deckRepositoryMock.editDeck(deckRepositoryMock.data[deck0.id]!.deck)
        deckRepositoryMock.data[deck1.id]!.deck.name = "Swift"
        try? deckRepositoryMock.editDeck(deckRepositoryMock.data[deck1.id]!.deck)
        deckRepositoryMock.data[deck3.id]!.deck.name = "Swift"
        try? deckRepositoryMock.editDeck(deckRepositoryMock.data[deck3.id]!.deck)
        
        sut.startup()
        
        var expectedResults: [Deck]?
        deckRepositoryMock
            .fetchDecksByIds([deck0.id, deck1.id, deck3.id])
            .sink { completion in
                print("aiai")
            } receiveValue: { decko in
                expectedResults = decko
            }
            .store(in: &cancelables)
        
        sut.decks = deckRepositoryMock.data.map(\.value.deck)
        
        sut.selectedCollection = nil
        sut.searchText = "Swift"
        
        XCTAssertEqual(sut.filteredDecks.sorted(by: self.sortById), expectedResults?.sorted(by: self.sortById))
    }
    
    func testCollectionDecksFilteredBySearchText() {
        
        deckRepositoryMock.data[deck1.id]!.deck.name = "Swift"
        deckRepositoryMock.data[deck1.id]!.deck.collectionId = UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!
        try? deckRepositoryMock.editDeck(deckRepositoryMock.data[deck1.id]!.deck)
        
        sut.decks = deckRepositoryMock.data.map(\.value.deck)
        
        let expectedResults = [deckRepositoryMock.data[deck1.id]!.deck]
        sut.selectedCollection = collectionRepositoryMock.collections[0]
        sut.searchText = "Swift"
        
        XCTAssertEqual(expectedResults, sut.filteredDecks)
    }
    
    func testDetailNameForSingleCollection() {
        sut.startup()
        sut.selectedCollection = collectionRepositoryMock.collections[0]
        XCTAssertEqual(collectionRepositoryMock.collections[0].name, sut.detailTitle)
    }
    
    func testDeleteSingleCollectionSuccessifully() throws {
        sut.startup()

        sut.collections = collectionRepositoryMock.collections
        let collectionToBeDeleted = collectionRepositoryMock.collections[0]
        try sut.deleteCollection(collectionToBeDeleted)
        
        let doesContainCollection = collectionRepositoryMock.collections.contains { $0.id == collectionToBeDeleted.id }
        
        XCTAssertFalse(doesContainCollection)
    }
    
    func testDeleteCollectionSuccessifully() throws {
        sut.startup()
        sut.collections = collectionRepositoryMock.collections
        let indexSet = IndexSet([0])
        let collectionToBeDeleted = collectionRepositoryMock.collections[0]
        
        try sut.deleteCollection(at: indexSet)
        
        let doesContainCollection = collectionRepositoryMock.collections.contains { $0.id == collectionToBeDeleted.id }
        
        XCTAssertFalse(doesContainCollection)
    }
    
    func testEditDeckSuccessfully() {
        sut.startup()
        sut.decks = deckRepositoryMock.data.map(\.value.deck)
        let deck = deckRepositoryMock.data[deck0.id]!.deck
        sut.selection.insert(deck.id)
        
        XCTAssertEqual(sut.selection.count, 1)
        
        XCTAssertEqual(sut.editDeck(), deck)
    }
    
    func testEditDeckWithWrongSelection() {
        sut.startup()
        sut.selection = .init()
        
        XCTAssertNil(sut.editDeck())
    }
    
    func testEditDeckWithWrongDeck() {
        sut.startup()
        let deck = Deck(id: UUID.init(), name: "deck", icon: IconNames.abc.rawValue, color: .beigeBrown, collectionId: UUID.init(), cardsIds: [], category: DeckCategory.arts, storeId: nil, description: "", ownerId: nil )
        
        sut.selection.insert(deck.id)
        
        XCTAssertNil(sut.editDeck())
    }
    
    func testDeleteDeckSuccessifully() throws {
        sut.decks = deckRepositoryMock.data.map(\.value.deck)
        sut.selection = Set(Array([deckRepositoryMock.data[deck0.id]!.deck, deckRepositoryMock.data[deck1.id]!.deck, deckRepositoryMock.data[deck2.id]!.deck]).map(\.id))
        XCTAssertEqual(4, deckRepositoryMock.data.count)
        
        sut.startup()
        try sut.deleteDecks()
        
        XCTAssertEqual(1, deckRepositoryMock.data.count)
    }
    
    func testDeleteDeckFailed() throws {
        sut.startup()
        
        sut.selection.insert(UUID())
        
        XCTAssertThrowsError(try sut.deleteDecks())
    }
    
    func testChangeDetailType() throws {
        sut.startup()
        XCTAssertEqual(sut.detailType, .grid)
        let current = displayCacherMock.getCurrentDetailType()
        XCTAssertNil(current)
        sut.changeDetailType(for: .table)
        XCTAssertEqual(sut.detailType, .table)
        XCTAssertEqual(.table, displayCacherMock.getCurrentDetailType())
    }
    
    func testDetailNameForAllDecks() {
        sut.startup()
        sut.selectedCollection = nil
        XCTAssertEqual(NSLocalizedString("baralhos_title", bundle: .module, comment: ""), sut.detailTitle)
    }
    
    @MainActor func testSetupDidEnterBackgroundPublisher() async {
        
        var deck = Deck(id: UUID(), name: "nomim", icon: "", color: .white, collectionId: nil, cardsIds: [], category: .arts, storeId: nil, description: "", ownerId: nil)
        
        var cards = [Card(id: UUID(), front: NSAttributedString(string: ""), back: NSAttributedString(string: ""), color: .white, datesLogs: DateLogs(), deckID: deck.id, woodpeckerCardInfo: WoodpeckerCardInfo(interval: 2, hasBeenPresented: true), history: [CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false), userGrade: .correctEasy, timeSpend: 10, date: dateHandler.today.addingTimeInterval(-86400))])]
        
        deck.session = Session(cardIds: cards.map(\.id), date: dateHandler.today.addingTimeInterval(86400), deckId: deck.id, id: UUID())
        
        cards = cards.map { var card = $0; card.deckID = deck.id; return card}
        deck.cardsIds = cards.map(\.id)
        
        
        try? deckRepositoryMock.createDeck(deck, cards: cards)
        
        sut.startup()
        let not0 = Notification(name: UIApplication.didEnterBackgroundNotification)
        notificationCenter.notificationSubjects[UIApplication.didEnterBackgroundNotification]?.send(not0)
        try? await Task.sleep(for: .seconds(1))
        
        
        XCTAssertEqual(self.userNotificationService.requests.count, 1)
        
    }
    
    @MainActor func testSetupDidEnterForeground() async throws {
        
        var deck = Deck(id: UUID(), name: "nomim", icon: "", color: .white, collectionId: nil, cardsIds: [], category: .arts, storeId: nil, description: "", ownerId: nil)
        
        var cards = [Card(id: UUID(), front: NSAttributedString(string: ""), back: NSAttributedString(string: ""), color: .white, datesLogs: DateLogs(), deckID: deck.id, woodpeckerCardInfo: WoodpeckerCardInfo(interval: 2, hasBeenPresented: true), history: [CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false), userGrade: .correctEasy, timeSpend: 10, date: dateHandler.today.addingTimeInterval(-86400))])]
        
        deck.session = Session(cardIds: cards.map(\.id), date: dateHandler.today.addingTimeInterval(86400), deckId: deck.id, id: UUID())
        
        cards = cards.map { var card = $0; card.deckID = deck.id; return card}
        deck.cardsIds = cards.map(\.id)
        
        
        try? deckRepositoryMock.createDeck(deck, cards: cards)
        
        sut.startup()
        userNotificationService.requests.append(UNNotificationRequest(identifier: "sfd", content: UNNotificationContent(), trigger: nil))
        
        
        let not = Notification(name: UIApplication.willEnterForegroundNotification)
        notificationCenter.notificationSubjects[UIApplication.willEnterForegroundNotification]?.send(not)
        try? await Task.sleep(for: .seconds(1))
        
        XCTAssertTrue(self.userNotificationService.requests.count == 0)
    }

    func testChangeDeckToNewCollection() {
        let collection = collectionRepositoryMock.collections.first!
        let deck = deck0!
        
        sut.change(deck: deck, to: collection)
        
        XCTAssertTrue(collectionRepositoryMock.collections.first!.decksIds.contains(deck.id))
        
    }
    
    func testRemoveCollectionFromDeck() {
        sut.startup()
        sut.decks = deckRepositoryMock.data.map(\.value.deck)
        sut.collections = collectionRepositoryMock.collections
        var deck = deck0!
        collectionRepositoryMock.collections[0].decksIds.append(deck.id)
        deck.collectionId = collectionRepositoryMock.collections.first!.id
        let count = collectionRepositoryMock.collections[0].decksIds.count
        
        sut.change(deck: deck, to: nil)
        
        XCTAssertEqual(collectionRepositoryMock.collections.first!.decksIds.count, count - 1)
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
        deck0 = newDeck()
        deck1 = newDeck()
        deck2 = newDeck()
        deck3 = newDeck()
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
             storeId: nil, description: "", ownerId: nil )
    }
    
    func sortById<T: Identifiable>(d0: T, d1: T) -> Bool where T.ID == UUID {
        return d0.id.uuidString > d1.id.uuidString
    }
    
    enum WoodpeckerState {
        case review, learn
    }
    
}
