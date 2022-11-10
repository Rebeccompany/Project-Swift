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

final class NotificationServiceTests: XCTestCase {
    var sut: NotificationService!
    var center: UserNotificationServiceMock!
    var dateHandler: DateHandlerMock!
    var deck: Deck!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        cancellables = .init()
        dateHandler = DateHandlerMock()
        deck = Deck(id: UUID(), name: "deck1", icon: "plus", color: .red, collectionId: UUID(), cardsIds: [], category: .arts, storeId: "")
        center = UserNotificationServiceMock()
        sut = NotificationService(center: center, dateHandler: dateHandler)
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
    
    func testTimeTrigger() {
        sut.scheduleNotification(for: deck, at: 5)
        let trigger = center.requests.first?.trigger as? UNTimeIntervalNotificationTrigger
        let time = trigger?.nextTriggerDate()?.timeIntervalSince1970
        XCTAssertNotEqual(time, 0)
    }
    
    func testSortNotification() {
        sut.scheduleNotification(for: deck, at: 5)
        let content = center.requests.first?.content
        XCTAssertNotEqual(content, nil)
    }
}
