//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 18/11/22.
//

import XCTest
import Combine

@testable import PublicDeckFeature
import Habitat
import Puffins
import StoreState
import Models

/*
 enum PublicDeckActions: Equatable {
     case loadDeck(id: String)
     case loadCards(id: String, page: Int)
     case reloadCards(id: String)
     case exitDeck
 }
 */

final class PublicDeckInteractorTests: XCTestCase {
    
    private var sut: PublicDeckInteractor!
    private var externalDeckService: ExternalDeckServiceMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        externalDeckService = .init()
        setupHabitatForIsolatedTesting(externalDeckService: externalDeckService)
        sut = .init()
        cancellables = .init()
    }
    
    override func tearDown() {
        sut = nil
        externalDeckService = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
    }
    
    func testLoadDeck() {
        var expectation = expectation(description: "deck is loaded")
        var initialState = PublicDeckState()
        
        let reducerEffect = sut.reduce(&initialState, action: .loadDeck(id: "1"))
        
        XCTAssertEqual(initialState, PublicDeckState())
        
        reducerEffect
            .sink { completion in
                switch completion {
                case.finished:
                    expectation.fulfill()
                case .failure(_):
                    break
                }
                
            } receiveValue: {[unowned self] newState in
                XCTAssertEqual(newState.deck, self.externalDeckService.deck(id: "1"))
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)

    }
}
