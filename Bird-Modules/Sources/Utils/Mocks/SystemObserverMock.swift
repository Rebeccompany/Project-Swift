//
//  SystemObserverMock.swift
//  
//
//  Created by Marcos Chevis on 19/09/22.
//

import Foundation
import Combine
//swiftlint:disable private_subject
public final class SystemObserverMock: SystemObserverProtocol {
    public let voiceOverDidChangeSubject = PassthroughSubject<Bool, Never>()
    public let willTermininateSubject = PassthroughSubject<Void, Never>()
    
    public init() {}
    
    public func voiceOverDidChange() -> AnyPublisher<Bool, Never> {
        voiceOverDidChangeSubject.eraseToAnyPublisher()
    }
    
    public func willTerminate() -> AnyPublisher<Void, Never> {
        willTermininateSubject.eraseToAnyPublisher()
    }
}
