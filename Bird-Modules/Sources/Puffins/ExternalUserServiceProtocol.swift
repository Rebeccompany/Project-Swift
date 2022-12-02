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
    func signIn(id: String) -> AnyPublisher<User, Error>
    func signUp(user: User) -> AnyPublisher<User, Error>
}
