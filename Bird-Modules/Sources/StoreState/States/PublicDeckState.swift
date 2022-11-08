//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Models

public struct PublicDeckState {
    public var deck: ExternalDeck?
    public var cards: [ExternalCard]
    public var currentPage: Int
    public var shouldLoadMore: Bool
    
    public init(deck: ExternalDeck? = nil, cards: [ExternalCard] = [], currentPage: Int = 0, shouldLoadMore: Bool = true) {
        self.deck = deck
        self.cards = cards
        self.currentPage = currentPage
        self.shouldLoadMore = shouldLoadMore
    }
}
