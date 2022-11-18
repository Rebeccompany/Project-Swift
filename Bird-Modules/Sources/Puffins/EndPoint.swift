//
//  EndPoint.swift
//  
//
//  Created by Rebecca Mello on 27/10/22.
//

import Foundation

public struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = ApiKeys.baseRoute
        components.path = "/\(path)"
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL \(components)")
        }
        
        return url
    }
}
