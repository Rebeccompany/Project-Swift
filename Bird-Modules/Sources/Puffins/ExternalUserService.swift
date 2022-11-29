//
//  ExternalUserService.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/11/22.
//

import Foundation
import Combine
import Models

public final class ExternalUserService: ExternalUserServiceProtocol {
    
    private let session: EndpointResolverProtocol
    public static let shared: ExternalUserService = .init()
    
    public init(session: EndpointResolverProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func signIn(id: String) -> AnyPublisher<UserDTO, Error> {
        session.dataTaskPublisher(for: .signin(id: id))
            .print("signIn")
            .decodeWhenSuccess(to: UserDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func signUp(user: UserDTO) -> AnyPublisher<UserDTO, Error> {
        session.dataTaskPublisher(for: .signup(user: user))
            .print("signUp")
            .decodeWhenSuccess(to: UserDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
