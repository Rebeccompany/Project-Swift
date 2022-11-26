//
//  UserDTO.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 25/11/22.
//

import Foundation

public struct UserDTO: Codable {
    public let appleIdentifier: String
    public let username: String
    
    public init(appleIdentifier: String, userName: String) {
        self.appleIdentifier = appleIdentifier
        self.username = userName
    }
}
