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
    private let not1: String = NSLocalizedString("notification1", bundle: .module, comment: "")
    private let not2: String = NSLocalizedString("notification2", bundle: .module, comment: "")
    private let not3: String = NSLocalizedString("notification3", bundle: .module, comment: "")
    private let not3_secondPart: String = NSLocalizedString("notification3_awaits", bundle: .module, comment: "")
    
    public init(center: UNUserNotificationCenter = UNUserNotificationCenter.current(), dateHandler: DateHandlerProtocol = DateHandler()) {
        self.center = center
        self.dateHandler = dateHandler
    }
    
    public func scheduleNotification(for deck: Deck, at time: TimeInterval) {
        let content = sortNotification(for: deck)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeTrigger(for: time), repeats: false)
        let request = UNNotificationRequest(identifier: deck.id.uuidString, content: content, trigger: trigger)
        
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
    
    public func cleanNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    private func timeTrigger(for time: TimeInterval) -> TimeInterval {
        let today = Date.now.timeIntervalSince1970
        if time > today {
            let timeTrigger = (time - today) - Double(TimeZone.autoupdatingCurrent.secondsFromGMT())
            return timeTrigger
        }
        return time
    }
    
    private func sortNotification(for deck: Deck) -> UNMutableNotificationContent {
        let notificationContent = [
            "\(not1) \(deck.name)",
            "\(not2) \(deck.name)",
            "\(not3) \(deck.name) \(not3_secondPart)"
        ]
        
        let notificationContentIndex = Int.random(in: 0...2)
        let content = UNMutableNotificationContent()
        
        content.title = NSLocalizedString("birdSound", bundle: .module, comment: "")
        content.body = notificationContent[notificationContentIndex]
        content.sound = UNNotificationSound.default
        
        return content
    }
}
