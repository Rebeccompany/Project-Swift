//
//  DocumentPicker.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 19/08/22.
//

import SwiftUI
import Flock
import Combine

struct DocumentPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    @Binding var fileContent: [ImportedCardInfo]
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText], asCopy: true)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        DocumentPickerCoordinator(fileContent: $fileContent)
    }
}

#warning("Testing not implemented")
final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding var fileContent: [ImportedCardInfo]
    private let converter: DeckConverter = DeckConverter()
    var navigate: (() -> Void)?
    
    init(fileContent: Binding<[ImportedCardInfo]>) {
        _fileContent = fileContent
        super.init()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first, let content = try? Data(contentsOf: fileURL, options: .mappedIfSafe)
        else { return }
        fileContent = (try? converter.convert(content)) ?? []
    }
}
