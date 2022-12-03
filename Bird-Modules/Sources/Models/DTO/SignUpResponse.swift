//
//  SignUpResponse.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 02/12/22.
//

import Foundation

public struct SignUpResponse: Codable {
    public let user: User
    public let refreshToken: String
    
    public init(user: User, refreshToken: String) {
        self.user = user
        self.refreshToken = refreshToken
    }
}
