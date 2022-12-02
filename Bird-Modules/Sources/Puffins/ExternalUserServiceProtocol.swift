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
    func signIn(id: String) -> AnyPublisher<UserDTO, Error>
    func signUp(user: UserDTO) -> AnyPublisher<UserDTO, Error>
    func deleteAccount(user: UserDTO) -> AnyPublisher<Void, Error>
}
