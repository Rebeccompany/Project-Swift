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
    let method: HTTPMethod
    let body: Data?
    
    init(path: String, method: HTTPMethod = .get, queryItems: [URLQueryItem] = [], body: Data? = nil) {
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.body = body
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
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method == .post || method == .put {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return request
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
