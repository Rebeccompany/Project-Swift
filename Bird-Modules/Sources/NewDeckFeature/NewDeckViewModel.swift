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
import Habitat

@MainActor
public class NewDeckViewModel: ObservableObject {
    @Published var deckName: String = ""
    @Published var currentSelectedColor: CollectionColor? = CollectionColor.red
    @Published var currentSelectedIcon: IconNames? = IconNames.gamecontroller
    @Published var currentSelectedCategory: DeckCategory = .others
    @Published var description: String = ""
    @Published var canSubmit: Bool = false
    @Published var showingErrorAlert: Bool = false
    
    let colors: [CollectionColor] = CollectionColor.allCases
    let icons: [IconNames] = IconNames.allCases
    
    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    @Dependency(\.uuidGenerator) private var uuidGenerator: UUIDGeneratorProtocol
    @Dependency(\.collectionRepository) private var collectionRepository: CollectionRepositoryProtocol
    
    private func setupDeckContentIntoFields(_ deck: Deck) {
        deckName = deck.name
        currentSelectedColor = deck.color
        currentSelectedIcon = IconNames(rawValue: deck.icon)
        description = deck.description
        currentSelectedCategory = deck.category
    }
    
    private var canSubmitPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($deckName, $currentSelectedColor, $currentSelectedIcon)
            .map { name, currentSelectedColor, currentSelectedIcon in
                !name.isEmpty && currentSelectedColor != nil && currentSelectedIcon != nil
            }
            .eraseToAnyPublisher()
    }
    
    func startUp(editingDeck: Deck?) {
        canSubmitPublisher
            .assign(to: &$canSubmit)
        
        if let editingDeck = editingDeck {
            setupDeckContentIntoFields(editingDeck)
        }
        
    }
    
    func createDeck(collection: DeckCollection?) throws -> UUID {
        guard let selectedColor = currentSelectedColor, let selectedIcon = currentSelectedIcon else {
            throw RepositoryError.couldNotCreate
        }
        let newId = uuidGenerator.newId()
        
        let deck = Deck(id: newId,
                        name: deckName,
                        icon: selectedIcon.rawValue.description,
                        color: selectedColor,
                        datesLogs: DateLogs(lastAccess: dateHandler.today, lastEdit: dateHandler.today, createdAt: dateHandler.today),
                        collectionId: collection?.id,
                        cardsIds: [],
                        spacedRepetitionConfig: SpacedRepetitionConfig(),
                        category: currentSelectedCategory,
                        storeId: nil,
                        description: description,
                        ownerId: nil)
        
        try deckRepository.createDeck(deck, cards: [])
        
        if let collection {
            try collectionRepository.addDeck(deck, in: collection)
        }
        
        return newId
    }
    
    func editDeck(editingDeck: Deck?) throws {
        guard let selectedColor = currentSelectedColor, let selectedIcon = currentSelectedIcon, var editingDeck = editingDeck else {
            return
        }

        editingDeck.name = deckName
        editingDeck.color = selectedColor
        editingDeck.icon = selectedIcon.rawValue.description
        editingDeck.datesLogs.lastAccess = dateHandler.today
        editingDeck.description = description
        editingDeck.datesLogs.lastEdit = dateHandler.today
        try deckRepository.editDeck(editingDeck)
    }
    
    func deleteDeck(editingDeck: Deck?) throws {
        guard let editingDeck = editingDeck else {
            return
        }
        
        try deckRepository.deleteDeck(editingDeck)
    }
    
}
