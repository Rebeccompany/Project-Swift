//
//  Routes.swift
//  
//
//  Created by Rebecca Mello on 27/10/22.
//

import Foundation

extension Endpoint {
    static var feed: Endpoint {
        Endpoint(path: "api/decks/feed")
    }
    
    static func cardsForDeck(id: String, page: Int = 0) -> Endpoint {
        let queryItem = URLQueryItem(name: "page", value: "\(page)")
        return Endpoint(path: "api/cards/\(id)", queryItems: [queryItem])
    }
}
