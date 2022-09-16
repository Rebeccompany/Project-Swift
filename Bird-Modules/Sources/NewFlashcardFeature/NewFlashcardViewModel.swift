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
    @Published var flashcardFront: String = ""
    @Published var flashcardBack: String = ""
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
        flashcardFront = NSAttributedString(card.front).string
        flashcardBack = NSAttributedString(card.back).string
        currentSelectedColor = card.color
    }
    
    func startUp() {
        Publishers.CombineLatest3($flashcardFront, $flashcardBack, $currentSelectedColor)
            .map(canSubmitData)
            .assign(to: &$canSubmit)
        
    }
    
    private func canSubmitData(front: String, back: String, currentSelectedColor: CollectionColor?) -> Bool {
        !front.isEmpty && !back.isEmpty && currentSelectedColor != nil
    }
    
    func createFlashcard() {
        guard let selectedColor = currentSelectedColor else {
            return
        }
        
        do {
            try deckRepository.addCard(
                Card(id: uuidGenerator.newId(),
                     front: AttributedString(stringLiteral: flashcardFront),
                     back: AttributedString(stringLiteral: flashcardBack),
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
    
    func editFlashcard() throws {
        guard let selectedColor = currentSelectedColor, var editingFlashcard = editingFlashcard else {
            return
        }
        
        editingFlashcard.front = AttributedString(stringLiteral: flashcardFront)
        editingFlashcard.back = AttributedString(stringLiteral: flashcardBack)
        editingFlashcard.color = selectedColor
        editingFlashcard.datesLogs.lastAccess = dateHandler.today
        editingFlashcard.datesLogs.lastEdit = dateHandler.today
        try deckRepository.editCard(editingFlashcard)
    }
    
    func deleteFlashcard() throws {
        guard let editingFlashcard = editingFlashcard else {
            return
        }
        
        try deckRepository.deleteCard(editingFlashcard)
    }
}
