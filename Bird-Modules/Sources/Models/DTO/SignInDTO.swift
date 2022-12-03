//
//  SignInDTO.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 02/12/22.
//

import Foundation

public struct SignInDTO: Codable {
    
    public let user: User
    public let authorizationCode: String
    
    public init(user: User, authorizationCode: String) {
        self.user = user
        self.authorizationCode = authorizationCode
    }
}
