//
//  File.swift
//  
//
//  Created by Rebecca Mello on 09/11/22.
//

import Foundation
import Models

public protocol NotificationServiceProtocol {
    func scheduleNotification(for deck: Deck, at time: TimeInterval)
    func requestAuthorizationForNotifications()
}
