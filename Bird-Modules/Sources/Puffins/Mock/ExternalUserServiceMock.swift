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
    
    public func signIn(id: String) -> AnyPublisher<UserDTO, Error> {
        if signInSuccess {
            return Just(UserDTO(appleIdentifier: id, userName: user.username)).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(outputType: UserDTO.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
    
    public func signUp(user: UserDTO) -> AnyPublisher<UserDTO, Error> {
        if signInSuccess {
            return Just(user).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(outputType: UserDTO.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
    
    public var user: UserDTO {
        UserDTO(appleIdentifier: "appleIdentifier", userName: "userName")
    }
    
    //swiftlint:disable trailing_closure
    public func deleteAccount(user: Models.UserDTO) -> AnyPublisher<Void, Error> {
        fatalError("deu erro")
    }
}
