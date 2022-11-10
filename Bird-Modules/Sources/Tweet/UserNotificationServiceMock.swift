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
    
    public func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        requests.append(request)
        guard let completionHandler else { return }
        
        if shouldThrowError {
            completionHandler(NSError())
        } else {
            completionHandler(nil)
        }
    }
}
