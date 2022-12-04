//
//  SignUpResponse.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 02/12/22.
//

import Foundation

public struct SignUpResponse: Codable {
    public let appleIdentifier: String
    public let username: String
    public let refreshToken: String
    
    public init(user: User, refreshToken: String) {
        self.appleIdentifier = user.appleIdentifier
        self.username = user.username
        self.refreshToken = refreshToken
    }
    
    public var user: User {
        User(appleIdentifier: appleIdentifier, userName: username)
    }
}
