//
//  ApiKeys.swift
//
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation

enum ApiKeys {
    static let baseRoute: String = "crow-dev.eba-udf2azmf.sa-east-1.elasticbeanstalk.com"
    static let bearerToken: String = "" 
}

public struct Secrets: Codable {
    let bearerToken: String
    
    private init(bearerToken: String) {
        self.bearerToken = bearerToken
    }
    
    //swiftlint: disable prefer_self_in_static_references
    public static let shared: Secrets = {
        guard
            let path = Bundle.module.url(forResource: "secrets", withExtension: "json"),
            let data = try? Data(contentsOf: path, options: .mappedIfSafe),
            let secrets = try? JSONDecoder().decode(Secrets.self, from: data)
        else { preconditionFailure("Failed to get Data from secrets JSON, verify if it exists") }
        
        return secrets
    }()
}
