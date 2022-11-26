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
    
    public func signIn(user: UserDTO) -> AnyPublisher<String, Error> {
        session.dataTaskPublisher(for: .signin(user: user))
            .decodeWhenSuccess(to: String.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func singUp(user: UserDTO) -> AnyPublisher<UserDTO, Error> {
        session.dataTaskPublisher(for: .signup(user: user))
            .decodeWhenSuccess(to: UserDTO.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
