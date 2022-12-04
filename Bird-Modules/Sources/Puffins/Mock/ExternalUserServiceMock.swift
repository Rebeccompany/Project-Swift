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
    public var authUserSuccess = true
    public var deleteAccountSucess = true
    
    public init() {}
    
    public func signIn(user: SignInDTO) -> AnyPublisher<SignUpResponse, Error> {
        if signInSuccess {
            return Just(SignUpResponse(user: user.user, refreshToken: "token")).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(outputType: SignUpResponse.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
    
    public func signUp(user: SignInDTO) -> AnyPublisher<SignUpResponse, Error> {
        if signUpSuccess {
            return Just(SignUpResponse(user: user.user, refreshToken: "token")).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(outputType: SignUpResponse.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
    
    public func authUser(id: String) -> AnyPublisher<Models.User, Error> {
        if authUserSuccess {
            return Just(User(appleIdentifier: id, userName: user.username)).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(outputType: User.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
    
    public var user: User {
        User(appleIdentifier: "appleIdentifier", userName: "userName")
    }
    
    public func revokeUser(data: Models.SignUpResponse) -> AnyPublisher<Void, Error> {
        if deleteAccountSucess {
            return Just(Void()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Fail(outputType: Void.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    
    public func deleteUser(id: String) -> AnyPublisher<Void, Error> {
        if deleteAccountSucess {
            return Just(Void()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Fail(outputType: Void.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}
