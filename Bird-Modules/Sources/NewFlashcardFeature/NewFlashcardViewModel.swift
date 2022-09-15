//
//  File.swift
//  
//
//  Created by Rebecca Mello on 15/09/22.
//

import Foundation
import Models
import HummingBird
import Storage
import Utils
import Combine

public class NewFlashcardViewModel: ObservableObject {
    @Published var flashcardFront: AttributedString = ""
    @Published var flashcardBack: AttributedString = ""
    @Published var currentSelectedColor: CollectionColor?
    @Published var canSubmit: Bool
    @Published var showingErrorAlert: Bool = false
    @Published var editingFlashcard: Card?
    
    var colors: [CollectionColor]
    var deck: Deck
    private let deckRepository: DeckRepositoryProtocol
    private let dateHandler: DateHandlerProtocol
    private let uuidGenerator: UUIDGeneratorProtocol
    
    
    public init(
        colors: [CollectionColor],
        editingFlashcard: Card? = nil,
        deckRepository: DeckRepositoryProtocol,
        deck: Deck,
        dateHandler: DateHandlerProtocol = DateHandler(),
        uuidGenerator: UUIDGeneratorProtocol = UUIDGenerator()
    ) {
        
        self.colors = colors
        self.deck = deck
        self.deckRepository = deckRepository
        self.dateHandler = dateHandler
        self.uuidGenerator = uuidGenerator
        self.canSubmit = false
        self.editingFlashcard = editingFlashcard
        
        if let editingFlashcard = editingFlashcard {
            setupDeckContentIntoFields(editingFlashcard)
        }
    }
    
    private func setupDeckContentIntoFields(_ card: Card) {
        flashcardFront = card.front
        flashcardBack = card.back
        currentSelectedColor = card.color
    }

    func startUp() {
        Publishers.CombineLatest3($flashcardFront, $flashcardBack, $currentSelectedColor)
            .map(canSubmitData)
            .assign(to: &$canSubmit)

    }
    
    private func canSubmitData(front: AttributedString, back: AttributedString, currentSelectedColor: CollectionColor?) -> Bool {
        !front.description.isEmpty && !back.description.isEmpty && currentSelectedColor != nil
    }
    
    func createFlashcard() {
        guard let selectedColor = currentSelectedColor else {
            return
        }

        do {
            try deckRepository.addCard(
                Card(id: uuidGenerator.newId(),
                     front: flashcardFront,
                     back: flashcardBack,
                     color: selectedColor,
                     datesLogs: DateLogs(lastAccess: dateHandler.today, lastEdit: dateHandler.today, createdAt: dateHandler.today),
                     deckID: deck.id,
                     woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                     history: []),
                to: deck)
                    
        } catch {
            showingErrorAlert = true
        }
    }
}
