//
//  ExternalUserServiceProtocol.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/11/22.
//

import Foundation
import Combine
import Models

public protocol ExternalUserServiceProtocol {
    func signIn(user: SignInDTO) -> AnyPublisher<SignUpResponse, Error>
    func signUp(user: SignInDTO) -> AnyPublisher<SignUpResponse, Error>
    func authUser(id: String) -> AnyPublisher<User, Error>
    func revokeUser(data: SignUpResponse) -> AnyPublisher<Void, Error>
    func deleteUser(id: String) -> AnyPublisher<Void, Error>
}
