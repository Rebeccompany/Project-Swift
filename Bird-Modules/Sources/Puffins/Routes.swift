//
//  Routes.swift
//  
//
//  Created by Rebecca Mello on 27/10/22.
//
import Models
import Foundation

extension Endpoint {
    static var feed: Endpoint {
        Endpoint(path: "api/decks/feed")
    }
    
    static func cardsForDeck(id: String, page: Int = 0) -> Endpoint {
        let queryItem = URLQueryItem(name: "page", value: "\(page)")
        return Endpoint(path: "api/cards/\(id)", queryItems: [queryItem])
    }
    
    static func deck(id: String) -> Endpoint {
        Endpoint(path: "api/decks/\(id)")
    }
    
    static func sendADeck(_ dto: Data) -> Endpoint {
        Endpoint(path: "api/decks", method: .post, body: dto)
    }
    
    static func deleteDeck(with id: String) -> Endpoint {
        Endpoint(path: "api/decks/\(id)", method: .delete)
    }
    
    static var login: Endpoint {
        Endpoint(path: "api/auth", method: .post, body: try? JSONEncoder().encode(Secrets.shared))
    }
    
    static func download(id: String) -> Endpoint {
        Endpoint(path: "api/decks/\(id)/download")
    }
    
    static func signin(user: SignInDTO) -> Endpoint {
        Endpoint(path: "api/auth/signin", method: .post, body: try? JSONEncoder().encode(user))
    }
    
    static func signup(user: SignInDTO) -> Endpoint {
        Endpoint(path: "api/auth/signup", method: .post, body: try? JSONEncoder().encode(user))
    }
    
    static func authUser(id: String) -> Endpoint {
        Endpoint(path: "api/auth/user", method: .post, body: try? JSONEncoder().encode(id))
    }
    
    static func revokeUser(data: SignUpResponse) -> Endpoint {
        Endpoint(path: "api/auth/revoke", method: .delete, body: try? JSONEncoder().encode(data))
    }
    
    static func update(id: String, _ dto: Data) -> Endpoint {
        Endpoint(path: "api/decks/\(id)", method: .put, body: dto)
    }
}
