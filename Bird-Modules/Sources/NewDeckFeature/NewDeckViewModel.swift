//
//  NewDeckViewModel.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//

import SwiftUI
import Models
import HummingBird
import Storage

class NewDeckViewModel: ObservableObject {
    @Published var deckName: String = ""
    var colors: [CollectionColor]
    var icons: [IconNames]
    var currentSelectedColor: CollectionColor? = nil
    var currentSelectedIcon: IconNames? = nil
    var collectionId: UUID
    private let deckRepository: DeckRepositoryProtocol
    
    init(colors: [CollectionColor], icons: [IconNames], currentSelectedColor: CollectionColor, currentSelectedIcon: IconNames, deckRepository: DeckRepositoryProtocol, collectionId: UUID) {
        self.colors = colors
        self.icons = icons
        self.currentSelectedColor = currentSelectedColor
        self.currentSelectedIcon = currentSelectedIcon
        self.collectionId = collectionId
        self.deckRepository = deckRepository
    }
    
    func createDeck() throws {
        guard let selectedColor = currentSelectedColor else {
            throw NSError()
        }
        
        guard let selectedIcon = currentSelectedIcon else {
            return
        }

        do {
            try deckRepository.createDeck(Deck(id: UUID(), name: deckName, icon: selectedIcon.rawValue.description, color: selectedColor, datesLogs: DateLogs(), collectionsIds: collectionId, cardsIds: [], spacedRepetitionConfig: SpacedRepetitionConfig()), cards: [])
                    
        } catch {
            #warning("fazer o erro")
        }
    }
}
