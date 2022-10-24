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
import Habitat

public class NewFlashcardViewModel: ObservableObject {
    @Published var flashcardFront: NSAttributedString = NSAttributedString(string: "")
    @Published var flashcardBack: NSAttributedString = NSAttributedString(string: "")
    @Published var currentSelectedColor: CollectionColor? = CollectionColor.red
    @Published var canSubmit: Bool = false
    @Published var showingErrorAlert: Bool = false
    
    var colors: [CollectionColor] = CollectionColor.allCases

    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    @Dependency(\.uuidGenerator) private var uuidGenerator: UUIDGeneratorProtocol
    

    private func setupDeckContentIntoFields(_ card: Card) {
        flashcardFront = card.front
        flashcardBack = card.back
        currentSelectedColor = card.color
    }
    
    private var canSubmitPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($flashcardFront, $flashcardBack, $currentSelectedColor)
            .map { front, back, currentSelectedColor in
                !front.string.isEmpty && !back.string.isEmpty && currentSelectedColor != nil
            }
            .eraseToAnyPublisher()
    }
    
    func startUp(editingFlashcard: Card?) {
        canSubmitPublisher
            .assign(to: &$canSubmit)
        
        if let editingFlashcard {
            setupDeckContentIntoFields(editingFlashcard)
        }
    }
    
    func createFlashcard(for deck: Deck) throws {
        guard let selectedColor = currentSelectedColor else {
            return
        }
        
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
    }
    
    func editFlashcard(editingFlashcard: Card?) throws {
        guard let selectedColor = currentSelectedColor, var editingFlashcard = editingFlashcard else {
            return
        }
        
        editingFlashcard.front = flashcardFront
        editingFlashcard.back = flashcardBack
        editingFlashcard.color = selectedColor
        editingFlashcard.datesLogs.lastAccess = dateHandler.today
        editingFlashcard.datesLogs.lastEdit = dateHandler.today
        try deckRepository.editCard(editingFlashcard)
    }
    
    func deleteFlashcard(editingFlashcard: Card?) throws {
        guard let editingFlashcard = editingFlashcard else {
            return
        }
        
        try deckRepository.deleteCard(editingFlashcard)
    }
}
