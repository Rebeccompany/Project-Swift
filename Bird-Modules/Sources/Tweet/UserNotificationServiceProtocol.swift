//
//  UserNotificationServiceProtocol.swift
//  
//
//  Created by Rebecca Mello on 09/11/22.
//

import SwiftUI

public protocol UserNotificationServiceProtocol {
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
}

extension UNUserNotificationCenter: UserNotificationServiceProtocol {
    
}
