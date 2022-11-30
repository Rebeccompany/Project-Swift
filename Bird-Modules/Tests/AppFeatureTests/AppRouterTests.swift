//
//  AppRouterTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/11/22.
//

import XCTest
@testable import AppFeature
import Storage
import Models
import Puffins
import Habitat
import Combine
import SwiftUI

final class AppRouterTests: XCTestCase {

    var sut: AppRouter!
    var externalDeckService: ExternalDeckServiceMock!
    var deckRepository: DeckRepositoryMock!
    var cancellables: Set<AnyCancellable>!
    var deck0: Deck!
    var deck1: Deck!
    var deck2: Deck!
    var deck3: Deck!
    
    @MainActor override func setUp() {
        externalDeckService = .init()
        deckRepository = .init()
        cancellables = .init()
        setupHabitatForIsolatedTesting(deckRepository: deckRepository, externalDeckService: externalDeckService)
        createData()
        sut = .init()
    }
    
    private func createData() {
        createDecks()
        try? deckRepository.createDeck(deck0, cards: [])
        try? deckRepository.createDeck(deck1, cards: [])
        try? deckRepository.createDeck(deck2, cards: [])
        try? deckRepository.createDeck(deck3, cards: [])
    }
    
    override func tearDown() {
        sut = nil
        externalDeckService = nil
        deckRepository = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
        deck0 = nil
        deck1 = nil
        deck2 = nil
        deck3 = nil
    }
    
    @MainActor func testOpenURLOnExistingDeckSuccessfully() {
        let url = URL(string: "spixii://opendeck/\(deck0.storeId!)")!
        
        sut.onOpen(url: url)
        
        XCTAssertEqual(sut.selectedTab, .study)
        XCTAssertEqual(sut.path, NavigationPath([StudyRoute.deck(deck0)]))
    }
    
    @MainActor func testOpenURLOnDownloadDeckSuccessfully() async throws {
        let url = URL(string: "spixii://opendeck/download1")!
        
        sut.onOpen(url: url)
        
        try await Task.sleep(for: .milliseconds(500))
        
        XCTAssertEqual(sut.selectedTab, .study)
        
        let downloadedDeck = self.downloadDeck
        XCTAssertNotNil(downloadedDeck)
        XCTAssertEqual(sut.path, NavigationPath([StudyRoute.deck(downloadedDeck!)]))
        
        
    }
    
    @MainActor func testOpenURLOnDownloadDeckWithCoreDataError() async throws {
        let url = URL(string: "spixii://opendeck/download1")!
        deckRepository.shouldThrowError = true
        
        sut.onOpen(url: url)
        
        try await Task.sleep(for: .milliseconds(500))
        
        let downloadDeck = self.downloadDeck
        XCTAssertNil(downloadDeck)
        XCTAssertEqual(sut.path, NavigationPath())
    }
    
    @MainActor func testOpenURLOnDowloadDeckWithNetworkError() async throws {
        let url = URL(string: "spixii://opendeck/download1")!
        externalDeckService.error = URLError(.badServerResponse)
        externalDeckService.shouldError = true
        
        sut.onOpen(url: url)
        
        try await Task.sleep(for: .milliseconds(500))
        
        let downloadDeck = self.downloadDeck
        XCTAssertNil(downloadDeck)
        XCTAssertEqual(sut.path, NavigationPath())
    }
    
    @MainActor func testOpenURLOnStoreSuccess() async throws {
        let url = URL(string: "spixii://store/download1")!
        
        sut.onOpen(url: url)
        
        try await Task.sleep(for: .milliseconds(500))
        
        XCTAssertEqual(sut.selectedTab, .store)
        XCTAssertEqual(sut.storePath, NavigationPath([externalDeckService.deck(id: "download1")]))
    }
    
    @MainActor func testOpenURLOnStoreFailed() async throws {
        let url = URL(string: "spixii://store/download1")!
        externalDeckService.error = URLError(.badServerResponse)
        externalDeckService.shouldError = true
        
        sut.onOpen(url: url)
        
        try await Task.sleep(for: .milliseconds(500))
        
        XCTAssertEqual(sut.storePath, NavigationPath())
    }
    
    @MainActor func testOpenURLOnLocalDeckSuccess() async throws {
        let url = URL(string: "spixii://openlocaldeck/\(deck0.id.uuidString)")!
        
        sut.onOpen(url: url)
        
        XCTAssertEqual(sut.selectedTab, .study)
        XCTAssertEqual(sut.path, NavigationPath([StudyRoute.deck(deck0)]))
    }
    
    @MainActor func testOpenURLOnLocalDeckFailed() async throws {
        let url = URL(string: "spixii://openlocaldeck/\(UUID().uuidString)")!
        
        sut.onOpen(url: url)
        
        XCTAssertEqual(sut.path, NavigationPath())
    }
    
    
    private var downloadDeck: Deck? {
        deckRepository
            .data
            .values
            .map(\.deck)
            .first(where: { $0.storeId == "download1" })
    }
    
    private func createDecks() {
        deck0 = newDeck(0)
        deck1 = newDeck(1)
        deck2 = newDeck(2)
        deck3 = newDeck(3)
    }
    
    private func newDeck(_ id: Int) -> Deck {
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
             storeId: "\(id)", description: "", ownerId: nil )
    }

}
