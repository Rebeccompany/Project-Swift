//
//  DocumentPicker.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 19/08/22.
//

import SwiftUI
import Combine

struct DocumentPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIDocumentPickerViewController
    
    @Binding var fileContent: Data
    
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
    @Binding var fileContent: Data
    
    init(fileContent: Binding<Data>) {
        _fileContent = fileContent
        super.init()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first, let content = try? Data(contentsOf: fileURL, options: .mappedIfSafe)
        else { return }
        fileContent = content
    }
}

// swiftlint:disable discouraged_optional_collection
public struct DeckFilePicker: View {
    @Binding public var selectedData: [ImportedCardInfo]?
    @ObservedObject private var viewModel: CSVPickerViewModel
    
    public init(selectedData: Binding<[ImportedCardInfo]?>,
                viewModel: CSVPickerViewModel = .init()) {
        self._selectedData = selectedData
        self.viewModel = viewModel
    }
    
    public var body: some View {
        DocumentPicker(fileContent: $viewModel.fileContent)
            .onReceive(viewModel.$fileContent) { data in
                selectedData = viewModel.convert(data)
            }
    }
}

public final class CSVPickerViewModel: ObservableObject {
    @Published var fileContent: Data
    private let deckConverter: DeckConverter
    
    public init() {
        self.fileContent = Data()
        self.deckConverter = .init()
    }
    
    func convert(_ data: Data) -> [ImportedCardInfo]? {
        try? deckConverter.convert(data)
    }
}
