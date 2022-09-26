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
    @Published var currentSelectedColor: CollectionColor? = CollectionColor.red
    @Published var currentSelectedIcon: IconNames? = IconNames.gamecontroller
    @Published var canSubmit: Bool
    @Published var showingErrorAlert: Bool = false
    @Published var editingDeck: Deck?
    
    var colors: [CollectionColor]
    var icons: [IconNames]
    var collection: DeckCollection?
    private let deckRepository: DeckRepositoryProtocol
    private let dateHandler: DateHandlerProtocol
    private let uuidGenerator: UUIDGeneratorProtocol
    private let collectionRepository: CollectionRepositoryProtocol
    
    
    public init(
        colors: [CollectionColor],
        icons: [IconNames],
        editingDeck: Deck? = nil,
        deckRepository: DeckRepositoryProtocol,
        collectionRepository: CollectionRepositoryProtocol = CollectionRepository.shared,
        collection: DeckCollection?,
        dateHandler: DateHandlerProtocol = DateHandler(),
        uuidGenerator: UUIDGeneratorProtocol = UUIDGenerator()
    ) {
        
        self.colors = colors
        self.icons = icons
        self.editingDeck = editingDeck
        self.collection = collection
        self.deckRepository = deckRepository
        self.collectionRepository = collectionRepository
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
    
    private var canSubmitPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($deckName, $currentSelectedColor, $currentSelectedIcon)
            .map { name, currentSelectedColor, currentSelectedIcon in
                !name.isEmpty && currentSelectedColor != nil && currentSelectedIcon != nil
            }
            .eraseToAnyPublisher()
    }
    
    func startUp() {
        canSubmitPublisher
            .assign(to: &$canSubmit)
        
    }
    
    func createDeck() throws {
        guard let selectedColor = currentSelectedColor, let selectedIcon = currentSelectedIcon else {
            return
        }

        let deck = Deck(id: uuidGenerator.newId(),
                        name: deckName,
                        icon: selectedIcon.rawValue.description,
                        color: selectedColor,
                        datesLogs: DateLogs(lastAccess: dateHandler.today, lastEdit: dateHandler.today, createdAt: dateHandler.today),
                        collectionId: collection?.id,
                        cardsIds: [],
                        spacedRepetitionConfig: SpacedRepetitionConfig())
        
        try deckRepository.createDeck(deck, cards: [])
        
        guard let collection
        else { return }
        try collectionRepository.addDeck(deck, in: collection)
    }
    
    func editDeck() throws {
        guard let selectedColor = currentSelectedColor, let selectedIcon = currentSelectedIcon, var editingDeck = editingDeck else {
            return
        }

        editingDeck.name = deckName
        editingDeck.color = selectedColor
        editingDeck.icon = selectedIcon.rawValue.description
        editingDeck.datesLogs.lastAccess = dateHandler.today
        editingDeck.datesLogs.lastEdit = dateHandler.today
        try deckRepository.editDeck(editingDeck)
    }
    
    func deleteDeck() throws {
        guard let editingDeck = editingDeck else {
            return
        }
        
        try deckRepository.deleteDeck(editingDeck)
    }
    
}
