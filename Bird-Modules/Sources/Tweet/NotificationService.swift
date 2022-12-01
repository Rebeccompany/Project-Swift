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
    
    public init(center: UserNotificationServiceProtocol = UNUserNotificationCenter.current(), dateHandler: DateHandlerProtocol = DateHandler()) {
        self.center = center
        self.dateHandler = dateHandler
    }
    
    public func scheduleNotification(for deck: Deck, at date: Date) {
        let content = sortNotification(for: deck)
        
        let components = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: deck.id.uuidString, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: nil)
    }
    
    public func requestAuthorizationForNotifications() {
        center.requestAuthorization(options: [UNAuthorizationOptions.alert, UNAuthorizationOptions.sound, UNAuthorizationOptions.badge]) { _, _ in }
    }
    
    public func cleanNotifications() {
        
        center.removeAllPendingNotificationRequests()
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
