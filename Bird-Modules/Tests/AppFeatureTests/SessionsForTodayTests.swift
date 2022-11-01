//
//  SessionsForTodayTests.swift
//  
//
//  Created by Caroline Taus on 01/11/22.
//

import Foundation
import XCTest
@testable import AppFeature
import Models
import Storage
import Habitat
import Combine

final class SessionsForTodayTests: XCTestCase {
    var sut: ContentViewModel!
    var deckRepositoryMock: DeckRepositoryMock!
    var displayCacherMock: DisplayCacher!
    var localStorageMock: LocalStorageMock!
    var collectionRepositoryMock: CollectionRepositoryMock!
    var cancelables: Set<AnyCancellable>!

    override func setUp() {
        deckRepositoryMock = DeckRepositoryMock()
        collectionRepositoryMock = CollectionRepositoryMock()
        localStorageMock = LocalStorageMock()
        displayCacherMock = DisplayCacher(localStorage: localStorageMock)
        setupHabitatForIsolatedTesting(deckRepository: deckRepositoryMock, collectionRepository: collectionRepositoryMock, displayCacher: displayCacherMock)
        sut = ContentViewModel()
        cancelables = Set<AnyCancellable>()
        sut.startup()
    }
    
    override func tearDown() {
        cancelables.forEach { cancellable in
            cancellable.cancel()
        }
        
        sut = nil
        collectionRepositoryMock = nil
        deckRepositoryMock = nil
        cancelables = nil
    }
    
    
    // Tests with cards that have dueDates only in the past
    func testSessionNeverStartedDDPast() {
        
    }
    
    func testSessionInProgressFromADayAgoDDPast() {
        
    }
    
    func testSessionInProgressFromTodayDDPast() {
        
    }
    
    func testSessionEndedInThePastDDPast() {
        
    }
    
    func testSessionEndedNowDDPast() {
        
    }
    
    // Tests with cards that have dueDates only for today
    func testSessionNeverStartedDDToday() {
        
    }
    
    func testSessionInProgressFromADayAgoDDToday() {
        
    }
    
    func testSessionInProgressFromTodayDDToday() {
        
    }
    
    func testSessionEndedInThePastDDToday() {
        
    }
    
    func testSessionEndedNowDDToday() {
        
    }
    
    // Tests with cards that have dueDates only for future
    func testSessionNeverStartedDDFuture() {
        
    }
    
    func testSessionInProgressFromADayAgoDDFuture() {
        
    }
    
    func testSessionInProgressFromTodayDDFuture() {
        
    }
    
    func testSessionEndedInThePastDDFuture() {
        
    }
    
    func testSessionEndedNowDDFuture() {
        
    }
    
    // Tests with cards that have dueDates = nil
    func testSessionNeverStartedDDNil() {
        
    }
    
    func testSessionInProgressFromADayAgoDDNil() {
        
    }
    
    func testSessionInProgressFromTodayDDNil() {
        
    }
    
    func testSessionEndedInThePastDDNil() {
        
    }
    
    func testSessionEndedNowDDNil() {
        
    }
    
    // Tests with cards that have dueDates mixed
    func testSessionNeverStartedDDPermutations() {
        
    }
    
    func testSessionInProgressFromADayAgoDDPermutations() {
        
    }
    
    func testSessionInProgressFromTodayDDPermutations() {
        
    }
    
    func testSessionEndedInThePastDDPermutations() {
        
    }
    
    func testSessionEndedNowDDPermutations() {
        
    }
    
}
