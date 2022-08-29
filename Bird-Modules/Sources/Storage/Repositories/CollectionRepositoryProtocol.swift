//
//  CollectionRepositoryProtocol.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Foundation
import Combine
import Models
import CoreData

public protocol CollectionRepositoryProtocol {
    func addDeck(_ deck: Deck, in collection: DeckCollection) throws
    func removeDeck(_ deck: Deck, from collection: DeckCollection) throws
}

