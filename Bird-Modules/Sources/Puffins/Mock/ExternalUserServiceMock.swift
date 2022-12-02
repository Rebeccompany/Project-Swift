//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/11/22.
//

import Models
import Foundation
import Combine

public final class ExternalUserServiceMock: ExternalUserServiceProtocol {
    public var signInSuccess = true
    public var signUpSuccess = true
    
    public init() {}
    
    public func signIn(id: String) -> AnyPublisher<User, Error> {
        if signInSuccess {
            return Just(User(appleIdentifier: id, userName: user.username)).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(outputType: User.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
    
    public func signUp(user: User) -> AnyPublisher<User, Error> {
        if signInSuccess {
            return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(outputType: User.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
    
    public var user: User {
        User(appleIdentifier: "appleIdentifier", userName: "userName")
    }
}
