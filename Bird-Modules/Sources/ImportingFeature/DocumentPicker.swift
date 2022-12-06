//
//  DocumentPicker.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 19/08/22.
//

import SwiftUI
import Models
import Flock
import Combine

#if os(iOS)

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileContent: [Card]
    var deckId: UUID
    var cancel: () -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText], asCopy: true)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        DocumentPickerCoordinator(fileContent: $fileContent, deckId: deckId) {
            cancel()
        }
    }
}

final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding private var fileContent: [Card]
    private let converter: DeckConverter = DeckConverter()
    private let deckId: UUID
    private let cancel: (() -> Void)?
    
    init(fileContent: Binding<[Card]>, deckId: UUID, cancel: @escaping () -> Void) {
        _fileContent = fileContent
        self.deckId = deckId
        self.cancel = cancel
        super.init()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first, let content = try? Data(contentsOf: fileURL, options: .mappedIfSafe)
        else { return }
        let importedContent = (try? converter.convert(content)) ?? []
        
        autoreleasepool {
            fileContent = importedContent.compactMap { ImportedCardInfoTransformer.transformToCard($0, deckID: deckId, cardColor: CollectionColor.allCases.randomElement() ?? .darkBlue) }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        guard let cancel else { return }
        cancel()
    }
    
    
}

#elseif os(macOS)
struct DocumentPicker: NSViewRepresentable {
    @Binding var fileContent: [Card]
    var deckId: UUID
    var cancel: () -> Void
    
    func makeNSView(context: Context) -> some NSView {
        NSView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}

#endif
