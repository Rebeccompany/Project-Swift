//
//  NotificationService.swift
//  
//
//  Created by Rebecca Mello on 09/11/22.
//

import SwiftUI
import Models
import Utils

public final class NotificationService: NotificationServiceProtocol {
    private let center: UserNotificationServiceProtocol
    private let dateHandler: DateHandlerProtocol
    
    public init(center: UserNotificationServiceProtocol = UNUserNotificationCenter.current(), dateHandler: DateHandlerProtocol = DateHandler()) {
        self.center = center
        self.dateHandler = dateHandler
    }
    
    public func scheduleNotification(for deck: Deck, at time: TimeInterval) {
        let content = sortNotification(for: deck)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeTrigger(for: time), repeats: false)
        let request = UNNotificationRequest(identifier: "identifier", content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }
    
    public func requestAuthorizationForNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    private func timeTrigger(for time: TimeInterval) -> TimeInterval {
        let today = dateHandler.today.timeIntervalSince1970
        let timeTrigger = time - today
        return timeTrigger
    }
    
    private func sortNotification(for deck: Deck) -> UNMutableNotificationContent {
        let notificationContent = [
            "Vem estudar \(deck.name)",
            "Ta achando que a vida é fácil, vem estudar \(deck.name)",
            "Já tá na hora né, o baralho \(deck.name) te espera"
        ]
        let notificationContentIndex = Int.random(in: 0...2)
        let content = UNMutableNotificationContent()
        
        content.title = "Piu!!"
        content.body = notificationContent[notificationContentIndex]
        content.sound = UNNotificationSound.default
        content.userInfo = ["CustomData": "Some Data"]
        
        return content
    }
}

public protocol UserNotificationServiceProtocol {
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
}

extension UNUserNotificationCenter: UserNotificationServiceProtocol {
    
}
