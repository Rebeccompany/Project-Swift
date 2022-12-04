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
    
    public func signIn(user: SignInDTO) -> AnyPublisher<SignUpResponse, Error> {
        session.dataTaskPublisher(for: .signin(user: user))
            .decodeWhenSuccess(to: SignUpResponse.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func signUp(user: SignInDTO) -> AnyPublisher<SignUpResponse, Error> {
        session.dataTaskPublisher(for: .signup(user: user))
            .decodeWhenSuccess(to: SignUpResponse.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func authUser(id: String) -> AnyPublisher<User, Error> {
        session.dataTaskPublisher(for: .authUser(id: id))
            .decodeWhenSuccess(to: User.self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func revokeUser(data: SignUpResponse) -> AnyPublisher<Void, Error> {
        session.dataTaskPublisher(for: .revokeUser(data: data))
            .verifyVoidSuccess()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    public func deleteUser(id: String) -> AnyPublisher<Void, Error> {
        session.dataTaskPublisher(for: .deleteUser(id: id))
            .verifyVoidSuccess()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
            
    }
}
