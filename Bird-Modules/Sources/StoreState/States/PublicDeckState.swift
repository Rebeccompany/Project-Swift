//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Models

public struct PublicDeckState: Equatable {
    public var deck: ExternalDeck?
    public var cards: [ExternalCard]
    public var currentPage: Int
    public var shouldLoadMore: Bool
    public var viewState: ViewState
    public var shouldDisplayDownloadedAlert: Bool
    
    public init(
        deck: ExternalDeck? = nil,
        cards: [ExternalCard] = [],
        currentPage: Int = 0,
        shouldLoadMore: Bool = true,
        viewState: ViewState = .loading,
        shouldDisplayDownloadedAlert: Bool = false) {
        self.deck = deck
        self.cards = cards
        self.currentPage = currentPage
        self.shouldLoadMore = shouldLoadMore
        self.viewState = viewState
        self.shouldDisplayDownloadedAlert = shouldDisplayDownloadedAlert
    }
}
