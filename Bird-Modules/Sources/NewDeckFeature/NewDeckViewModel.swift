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
import Utils
import Combine

public class NewDeckViewModel: ObservableObject {
    @Published var deckName: String = ""
    @Published var currentSelectedColor: CollectionColor? = nil
    @Published var currentSelectedIcon: IconNames? = nil
    @Published var canSubmit: Bool
    @Published var showingErrorAlert: Bool = false
    @Published var editingDeck: Deck?
    
    var colors: [CollectionColor]
    var icons: [IconNames]
    var collectionId: [UUID]
    private let deckRepository: DeckRepositoryProtocol
    private let dateHandler: DateHandlerProtocol
    private let uuidGenerator: UUIDGeneratorProtocol
    
    
    public init(
        colors: [CollectionColor],
         icons: [IconNames],
         editingDeck: Deck? = nil,
         deckRepository: DeckRepositoryProtocol,
         collectionId: [UUID],
         dateHandler: DateHandlerProtocol = DateHandler(),
         uuidGenerator: UUIDGeneratorProtocol = UUIDGenerator()
    ) {
        
        self.colors = colors
        self.icons = icons
        self.editingDeck = editingDeck
        self.collectionId = collectionId
        self.deckRepository = deckRepository
        self.dateHandler = dateHandler
        self.uuidGenerator = uuidGenerator
        self.canSubmit = false
        
        if let editingDeck = editingDeck {
            setupDeckContentIntoFields(editingDeck)
        }
    }
    
    private func setupDeckContentIntoFields(_ deck: Deck) {
        deckName = deck.name
        currentSelectedColor = deck.color
        currentSelectedIcon = IconNames(rawValue: deck.icon)
    }
    
    func startUp() {
        Publishers.CombineLatest3($deckName, $currentSelectedColor, $currentSelectedIcon)
            .map(canSubmitData)
            .assign(to: &$canSubmit)
        
    }
    
    private func canSubmitData(name: String, currentSelectedColor: CollectionColor?, currentSelectedIcon: IconNames?) -> Bool {
        !name.isEmpty && currentSelectedColor != nil && currentSelectedIcon != nil
    }
    
    func createDeck()  {
        guard let selectedColor = currentSelectedColor, let selectedIcon = currentSelectedIcon else {
            return
        }

        do {
            try deckRepository.createDeck(
                Deck(id: uuidGenerator.newId(),
                     name: deckName,
                     icon: selectedIcon.rawValue.description,
                     color: selectedColor,
                     datesLogs: DateLogs(lastAccess: dateHandler.today, lastEdit: dateHandler.today, createdAt: dateHandler.today),
                     collectionsIds: collectionId,
                     cardsIds: [],
                     spacedRepetitionConfig: SpacedRepetitionConfig()),
                cards: [])
                    
        } catch {
            showingErrorAlert = true
        }
    }
    
    func editDeck() {
        guard let selectedColor = currentSelectedColor, let selectedIcon = currentSelectedIcon, var editingDeck = editingDeck else {
            return
        }

        do {
            editingDeck.name = deckName
            editingDeck.color = selectedColor
            editingDeck.icon = selectedIcon.rawValue.description
            editingDeck.datesLogs.lastAccess = dateHandler.today
            editingDeck.datesLogs.lastEdit = dateHandler.today
            try deckRepository.editDeck(editingDeck)
                    
        } catch {
            showingErrorAlert = true
        }
    }
    
    func deleteDeck() {
        guard let editingDeck = editingDeck else {
            return
        }

        do {
            try deckRepository.deleteDeck(editingDeck)
        } catch {
            showingErrorAlert = true
        }
    }
}
