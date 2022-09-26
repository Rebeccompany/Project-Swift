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
    @Published var currentSelectedColor: CollectionColor? = CollectionColor.red
    @Published var canSubmit: Bool = false
    @Published var showingErrorAlert: Bool = false
    @Published var editingFlashcard: Card? = nil
    
    var colors: [CollectionColor] = CollectionColor.allCases

    private let deckRepository: DeckRepositoryProtocol = DeckRepositoryMock()
    private let dateHandler: DateHandlerProtocol = DateHandlerMock()
    private let uuidGenerator: UUIDGeneratorProtocol = UUIDHandlerMock()
    

    private func setupDeckContentIntoFields(_ card: Card) {
        flashcardFront = NSAttributedString(card.front).string
        flashcardBack = NSAttributedString(card.back).string
        currentSelectedColor = card.color
    }
    
    private var canSubmitPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($flashcardFront, $flashcardBack, $currentSelectedColor)
            .map { front, back, currentSelectedColor in
                !front.isEmpty && !back.isEmpty && currentSelectedColor != nil
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
                 front: AttributedString(stringLiteral: flashcardFront),
                 back: AttributedString(stringLiteral: flashcardBack),
                 color: selectedColor,
                 datesLogs: DateLogs(lastAccess: dateHandler.today, lastEdit: dateHandler.today, createdAt: dateHandler.today),
                 deckID: deck.id,
                 woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: false),
                 history: []),
            to: deck)
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
