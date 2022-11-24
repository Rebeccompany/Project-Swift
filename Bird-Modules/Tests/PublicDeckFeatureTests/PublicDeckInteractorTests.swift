//
//  PublicDeckInteractorTests.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 18/11/22.
//

@testable import PublicDeckFeature
import XCTest
import Combine
import Habitat
import Puffins
import StoreState
import Models
import Storage

final class PublicDeckInteractorTests: XCTestCase {
    
    private var sut: PublicDeckInteractor!
    private var externalDeckService: ExternalDeckServiceMock!
    private var deckRepository: DeckRepositoryMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        externalDeckService = .init()
        deckRepository = .init()
        setupHabitatForIsolatedTesting(deckRepository: deckRepository, externalDeckService: externalDeckService)
        sut = .init()
        cancellables = .init()
    }
    
    override func tearDown() {
        sut = nil
        externalDeckService = nil
        deckRepository = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
    }
    
    func testLoadDeck() {
        let expectation = expectation(description: "deck is loaded")
        var initialState = PublicDeckState()
        
        let reducerEffect = sut.reduce(&initialState, action: .loadDeck(id: "1"))
        XCTAssertEqual(initialState.viewState, .loading)
        XCTAssertEqual(initialState, PublicDeckState())
        
        reducerEffect
            .sink {[unowned self] newState in
                XCTAssertEqual(newState.deck, self.externalDeckService.deck(id: "1"))
                XCTAssertEqual(newState.viewState, .loaded)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)

    }
    
    func testLoadDeckWithError() {
        let expectation = expectation(description: "deck is loaded")
        var initialState = PublicDeckState()
        
        externalDeckService.error = URLError(.dataNotAllowed)
        externalDeckService.shouldError = true
        
        let reducerEffect = sut.reduce(&initialState, action: .loadDeck(id: "1"))
        XCTAssertEqual(initialState.viewState, .loading)
        XCTAssertEqual(initialState, PublicDeckState())
        
        reducerEffect
            .sink { newState in
                XCTAssertEqual(newState.viewState, .error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)

    }
    
    func testLoadCardOnFirstPageSuccess() {
        let expetation = expectation(description: "load cards")
        var initialState = PublicDeckState()
        
        let reducerEffect = sut.reduce(&initialState, action: .loadCards(id: "1", page: 0))
        
        XCTAssertEqual(initialState.currentPage, 1)
        
        reducerEffect
            .sink {[unowned self] newState in
                XCTAssertTrue(newState.shouldLoadMore)
                XCTAssertEqual(newState.cards, self.externalDeckService.cards)
                expetation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expetation], timeout: 1)
    }
    
    func testLoadCardOnEmptyPageSuccess() {
        let expetation = expectation(description: "load cards")
        var initialState = PublicDeckState()
        
        let reducerEffect = sut.reduce(&initialState, action: .loadCards(id: "1", page: 1))
        
        XCTAssertEqual(initialState.currentPage, 1)
        
        reducerEffect
            .sink { newState in
                XCTAssertFalse(newState.shouldLoadMore)
                expetation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expetation], timeout: 1)
    }
    
    func testLoadCardFailed() {
        let expetation = expectation(description: "load cards")
        var initialState = PublicDeckState()
        
        externalDeckService.error = URLError(.dataNotAllowed)
        externalDeckService.shouldError = true
        
        let reducerEffect = sut.reduce(&initialState, action: .loadCards(id: "1", page: 1))
        
        XCTAssertEqual(initialState.currentPage, 1)
        
        reducerEffect
            .sink { newState in
                XCTAssertEqual(newState.viewState, .error)
                expetation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expetation], timeout: 1)
    }
    
    func testReloadCardsSuccess() {
        let expetation = expectation(description: "reload cards")
        var initialState = PublicDeckState()
        
        let reducerEffect = sut.reduce(&initialState, action: .reloadCards(id: "1"))
        
        XCTAssertEqual(initialState.currentPage, 0)
        XCTAssertEqual(initialState.cards, [])
        
        reducerEffect
            .sink { newState in
                XCTAssertTrue(newState.shouldLoadMore)
                XCTAssertEqual(newState.cards, self.externalDeckService.cards)
                XCTAssertEqual(newState.currentPage, 1)
                expetation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expetation], timeout: 1)
    }
    
    func testReloadCardsFailed() {
        let expetation = expectation(description: "reload cards")
        var initialState = PublicDeckState()
        
        externalDeckService.error = URLError(.dataNotAllowed)
        externalDeckService.shouldError = true
        
        let reducerEffect = sut.reduce(&initialState, action: .reloadCards(id: "1"))
        
        XCTAssertEqual(initialState.currentPage, 0)
        XCTAssertEqual(initialState.cards, [])
        
        reducerEffect
            .sink { newState in
                XCTAssertEqual(newState.viewState, .error)
                expetation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expetation], timeout: 1)
    }
    
    func testDownloadDeck() {
        let expetation = expectation(description: "download deck")
        var initialState = PublicDeckState()
        
        let reducerEffect = sut.reduce(&initialState, action: .downloadDeck(id: "1"))
        
        XCTAssertEqual(initialState.viewState, .loading)
        
        reducerEffect
            .sink {[unowned self] newState in
                XCTAssertEqual(newState.viewState, .loaded)
                XCTAssertTrue(newState.shouldDisplayDownloadedAlert)
                XCTAssertEqual(deckRepository.data.values.count, 1)
                XCTAssertEqual(deckRepository.data.values.first?.deck.storeId, "1")
                XCTAssertEqual(deckRepository.data.values.first?.cards.count, 10)
                expetation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expetation], timeout: 1)
    }
    
    func testDownloadDeckFailed() {
        let expetation = expectation(description: "download deck")
        var initialState = PublicDeckState()
        
        externalDeckService.error = URLError(.dataNotAllowed)
        externalDeckService.shouldError = true
        
        let reducerEffect = sut.reduce(&initialState, action: .downloadDeck(id: "1"))
        
        XCTAssertEqual(initialState.viewState, .loading)
        
        reducerEffect
            .sink {newState in
                XCTAssertEqual(newState.viewState, .error)
                expetation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expetation], timeout: 1)
    }
}
