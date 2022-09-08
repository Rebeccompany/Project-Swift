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

class NewDeckViewModel: ObservableObject {
    @Published var deckName: String = ""
    @Published var currentSelectedColor: CollectionColor? = nil
    @Published var currentSelectedIcon: IconNames? = nil
    @Published var canSubmit: Bool
    
    var colors: [CollectionColor]
    var icons: [IconNames]
    var collectionId: [UUID]
    private let deckRepository: DeckRepositoryProtocol
    private let dateHandler: DateHandlerProtocol
    private let uuidGenerator: UUIDGeneratorProtocol
    
    
    init(
        colors: [CollectionColor],
         icons: [IconNames],
         deckRepository: DeckRepositoryProtocol,
         collectionId: [UUID],
         dateHandler: DateHandlerProtocol = DateHandler(),
         uuidGenerator: UUIDGeneratorProtocol = UUIDGenerator()
    ) {
        
        self.colors = colors
        self.icons = icons
        self.collectionId = collectionId
        self.deckRepository = deckRepository
        self.dateHandler = dateHandler
        self.uuidGenerator = uuidGenerator
        self.canSubmit = false
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
            #warning("fazer o erro")
        }
    }
}
