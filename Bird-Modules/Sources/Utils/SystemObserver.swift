//
//  SystemObserver.swift
//  
//
//  Created by Marcos Chevis on 19/09/22.
//

import Foundation
import Combine
#if os(iOS)
import UIKit
public func getIsVOOn() -> Bool {
    UIAccessibility.isVoiceOverRunning
}
#else
import AppKit
public func getIsVOOn() -> Bool {
    NSWorkspace.shared.isVoiceOverEnabled
}
#endif


public protocol SystemObserverProtocol {
    func voiceOverDidChange() -> AnyPublisher<Bool, Never>
    func willTerminate() -> AnyPublisher<Void, Never>
}

public final class SystemObserver: SystemObserverProtocol {
    public init() {}
    
    #if os(macOS)
    public func voiceOverDidChange() -> AnyPublisher<Bool, Never> {
        NSWorkspace.shared.publisher(for: \.isVoiceOverEnabled)
            .eraseToAnyPublisher()
    }
    
    public func willTerminate() -> AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)
            .map { _ in
                ()
            }
            .eraseToAnyPublisher()
    }
    #else
    public func voiceOverDidChange() -> AnyPublisher<Bool, Never> {
        NotificationCenter.default.publisher(for: UIAccessibility.voiceOverStatusDidChangeNotification)
            .map {_ in
                UIAccessibility.isVoiceOverRunning
            }
            .eraseToAnyPublisher()
    }
    
    public func willTerminate() -> AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .map { _ in
                ()
            }
            .eraseToAnyPublisher()
    }
    #endif
}
