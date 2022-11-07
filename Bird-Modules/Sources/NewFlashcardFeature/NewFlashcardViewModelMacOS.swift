//
//  NewFlashcardViewModelMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 07/11/22.
//

import Foundation
import Models
import HummingBird
import Storage
import Utils
import Combine
import Habitat

#if os(macOS)
public class NewFlashcardViewModelMacOS: ObservableObject {
    @Published var flashcardFront: NSAttributedString = NSAttributedString(string: "")
    @Published var flashcardBack: NSAttributedString = NSAttributedString(string: "")
    @Published var currentSelectedColor: CollectionColor? = CollectionColor.red
    @Published var canSubmit: Bool = false
    @Published var showingErrorAlert: Bool = false
    @Published var deck: Deck?
    @Published var editingFlashcard: Card?
    private var cancellables = Set<AnyCancellable>()
    
    var colors: [CollectionColor] = CollectionColor.allCases
    
    private var updateTextFieldContextSubject: PassthroughSubject<Void, Never> = .init()
    var updateTextFieldContextPublisher: AnyPublisher<Void, Never> {
        updateTextFieldContextSubject.eraseToAnyPublisher()
    }

    @Dependency(\.deckRepository) private var deckRepository: DeckRepositoryProtocol
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    @Dependency(\.uuidGenerator) private var uuidGenerator: UUIDGeneratorProtocol
    

    func setupDeckContentIntoFields() {
        guard let editingFlashcard = editingFlashcard else { return }
        flashcardFront = editingFlashcard.front
        flashcardBack = editingFlashcard.back
        currentSelectedColor = editingFlashcard.color
    }
    
    #warning("testar")
    func reset() {
        flashcardFront = NSAttributedString(string: "")
        flashcardBack = NSAttributedString(string: "")
        currentSelectedColor = .red
        updateTextFieldContextSubject.send()
    }
    
    private var canSubmitPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($flashcardFront, $flashcardBack, $currentSelectedColor)
            .map { front, back, currentSelectedColor in
                !front.string.isEmpty && !back.string.isEmpty && currentSelectedColor != nil
            }
            .eraseToAnyPublisher()
    }
    
    func startUp(_ data: NewFlashcardWindowData) {
        canSubmitPublisher
            .assign(to: &$canSubmit)
    
        fetchInitialDeck(data.deckId)
        fetchEditingCard(data.editingFlashcardId)
    }
    
    func fetchInitialDeck(_ deckId: UUID) {
        deckRepository
            .fetchDeckById(deckId)
            .map { $0 as Deck? }
            .replaceError(with: nil)
            .assign(to: &$deck)
    }
    
    func fetchEditingCard(_ cardId: UUID?) {
        guard let cardId else {
            return
        }
        
        return deckRepository
            .fetchCardById(cardId)
            .map { $0 as Card? }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink {[weak self] card in
                guard let card else { return }
                self?.editingFlashcard = card
                self?.setupDeckContentIntoFields()
                self?.updateTextFieldContextSubject.send(Void())
            }
            .store(in: &cancellables)
    }
    
    func createFlashcard() throws {
        guard let selectedColor = currentSelectedColor, let deck = deck else {
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
    
    func editFlashcard() throws {
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
    
    func deleteFlashcard() throws {
        guard let editingFlashcard = editingFlashcard else {
            return
        }
        
        try deckRepository.deleteCard(editingFlashcard)
    }
}
#endif
