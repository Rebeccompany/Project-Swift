//
//  UserNotificationServiceMock.swift
//  
//
//  Created by Rebecca Mello on 10/11/22.
//

import Foundation
import SwiftUI

public class UserNotificationServiceMock: UserNotificationServiceProtocol {
    
    
    public var requests: [UNNotificationRequest] = []
    public var shouldThrowError: Bool = false
    
    public init() {}
    
    public func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        requests.append(request)
        guard let completionHandler else { return }
        
        if shouldThrowError {
            completionHandler(NSError())
        } else {
            completionHandler(nil)
        }
    }
    
    public func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        if shouldThrowError {
            completionHandler(false, NSError())
        } else {
            completionHandler(true, nil)
        }
    }
    
    public func removeAllPendingNotificationRequests() {
        requests = []
    }

}
