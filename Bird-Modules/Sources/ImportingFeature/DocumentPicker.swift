//
//  File.swift
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
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        DocumentPickerCoordinator(fileContent: $fileContent)
    }
}


final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding var fileContent: Data
    
    init(fileContent: Binding<Data>) {
        _fileContent = fileContent
        super.init()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let fileURL = urls.first, let content = try? Data(contentsOf: fileURL, options: .mappedIfSafe)
        else { return }
        print(String(data: content, encoding: .utf8))
        fileContent = content
    }
}


public struct DeckFilePicker: View {
    @Binding public var selectedData: [ImportedCardInfo]?
    @StateObject private var viewModel: CSVPickerViewModel = .init()
    
    public init(selectedData: Binding<[ImportedCardInfo]?>) {
        self._selectedData = selectedData
    }
    
    public var body: some View {
        DocumentPicker(fileContent: $viewModel.fileContent)
            .onReceive(viewModel.convertedFilePublisher) { data in
                selectedData = data
            }
    }
}

final class CSVPickerViewModel: ObservableObject {
    @Published var fileContent = Data()
    private let deckConverter: DeckConverter = .init()
    
    var convertedFilePublisher: AnyPublisher<[ImportedCardInfo]?, Never> {
        $fileContent
            .tryMap(deckConverter.convert)
            .print()
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
