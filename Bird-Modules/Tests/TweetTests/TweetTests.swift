//
//  TweetTests.swift
//  
//
//  Created by Rebecca Mello on 10/11/22.
//

import Foundation

import XCTest
@testable import Tweet
import Models
import Combine
import Utils
import Habitat

final class NotificationServiceTests: XCTestCase {
    var sut: NotificationService!
    var center: UserNotificationServiceMock!
    var dateHandler: DateHandlerMock!
    var deck: Deck!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = .init()
        dateHandler = DateHandlerMock()
        deck = Deck(id: UUID(), name: "deck1", icon: "plus", color: .red, collectionId: UUID(), cardsIds: [], category: .arts, storeId: "", description: "", ownerId: nil)
        center = UserNotificationServiceMock()
        setupHabitatForIsolatedTesting()
        sut = NotificationService(center: center)
    }
    
    override func tearDown() {
        sut = nil
        deck = nil
        center = nil
        cancellables.forEach {
            $0.cancel()
        }
        cancellables = nil
    }
    
    func testSortNotification() {
        sut.scheduleNotification(for: deck, at: dateHandler.today.addingTimeInterval(5))
        let content = center.requests.first?.content
        XCTAssertNotEqual(content, nil)
    }
}
