//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 07/11/22.
//

import Foundation
import Models

public final class PublicDeckStore: ObservableObject {
    
    @Published var deckState: PublicDeckState
    
    init(state: PublicDeckState) {
        self.deckState = state
    }
}

struct PublicDeckState {
    var deck: ExternalDeck? = nil
    var cards: [ExternalCard] = []
    var currentPage: Int = 0
    var shouldLoadMore: Bool = true
}
