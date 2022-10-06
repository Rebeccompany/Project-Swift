//
//  ImportViewModel.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/10/22.
//

import Foundation
import Models
import Habitat
import Storage

final class ImportViewModel: ObservableObject {
    
    @Dependency(\.deckRepository) private var repository: DeckRepositoryProtocol
    
    func save(_ cards: [Card], to deck: Deck) {
        cards.forEach { card in
            try? repository.addCard(card, to: deck)
        }
    }
}
