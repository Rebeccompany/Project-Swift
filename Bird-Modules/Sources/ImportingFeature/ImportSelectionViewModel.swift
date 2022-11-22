//
//  ImportSelectionViewModel.swift
//  
//
//  Created by Nathalia do Valle Papst on 22/11/22.
//

import Foundation
import SwiftUI
import Models

#if os(macOS)
final class ImportSelectionViewModel: ObservableObject {
    func openDocumentPicker(converter: DeckConverter, deckId: UUID, fileContent: Binding<[Card]>) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        convertFileToFlashcards(panel: panel, converter: converter, deckId: deckId, fileContent: fileContent)
    }
    
    func convertFileToFlashcards(panel: NSOpenPanel, converter: DeckConverter, deckId: UUID, fileContent: Binding<[Card]>) {
        if panel.runModal() == .OK {
            guard let fileURL = panel.url, let content = try? Data(contentsOf: fileURL, options: .mappedIfSafe)
            else { return }
            let importedContent = (try? converter.convert(content)) ?? []
            
            autoreleasepool {
                fileContent.wrappedValue = importedContent.compactMap { ImportedCardInfoTransformer.transformToCard($0, deckID: deckId, cardColor: CollectionColor.allCases.randomElement() ?? .darkBlue) }
            }
        }
    }
}
#endif
