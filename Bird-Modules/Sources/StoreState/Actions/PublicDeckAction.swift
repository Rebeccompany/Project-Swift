//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Foundation

enum PublicDeckActions: Equatable {
    case loadDeck(id: String)
    case loadCards(id: String, page: Int)
    case reloadCards(id: String)
}
