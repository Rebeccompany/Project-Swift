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
    func signIn(user: UserDTO) -> AnyPublisher<String, Error>
    func singUp(user: UserDTO) -> AnyPublisher<UserDTO, Error>
}
