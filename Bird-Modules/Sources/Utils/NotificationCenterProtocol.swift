//
//  File.swift
//  
//
//  Created by Marcos Chevis on 30/11/22.
//

import Foundation
import Combine

public protocol NotificationCenterProtocol: AnyObject {
    func notificationPublisher(for name: Notification.Name, object: AnyObject?) -> AnyPublisher<Notification, Never>
}


extension NotificationCenter: NotificationCenterProtocol {
    public func notificationPublisher(for name: Notification.Name, object: AnyObject? = nil) -> AnyPublisher<Notification, Never> {
        publisher(for: name, object: object).eraseToAnyPublisher()
    }
}

public final class NotificationCenterMock: NotificationCenterProtocol {
    
    public var notificationNames: [Notification.Name] = []
    public var notificationSubject: PassthroughSubject<Notification, Never> = .init()
    
    public init() {}
    
    public func notificationPublisher(for name: Notification.Name, object: AnyObject? = nil) -> AnyPublisher<Notification, Never> {
        return notificationSubject.eraseToAnyPublisher()
    }
}
