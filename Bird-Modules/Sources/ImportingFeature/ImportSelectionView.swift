//
//  ImportSelectionView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/22.
//

import SwiftUI
import HummingBird
import Flock
import Models

struct ImportSelectionView: View {
#if os(iOS)
    @Binding var isPresenting: Bool
    @Binding var presentFileSheet: Bool
#elseif os(macOS)
    @State private var filename = "Filename"
    @EnvironmentObject private var routerStore: RouterStore<ImportRoute>
    @Binding private var fileContent: [Card]
    private let deckId: UUID
    private let converter: DeckConverter = DeckConverter()
    @StateObject private var viewModel = ImportSelectionViewModel()
    
    init(fileContent: Binding<[Card]>, deckId: UUID) {
        self._fileContent = fileContent
        self.deckId = deckId
    }
#endif
    
    var body: some View {
        VStack {
            GroupBox(NSLocalizedString("csv_title", bundle: .module, comment: "")) {
                VStack(alignment: .leading) {
                    Text("csv_description", bundle: .module)
                    Text("csv_anki_description", bundle: .module)
                    if let convertURL = URL(string: "https://www.easy4u.tools/apkg2csv") {
                        Link(
                            NSLocalizedString("csv_anki_link", bundle: .module, comment: ""),
                            destination: convertURL
                        )
                        .foregroundColor(HBColor.actionColor)
                        .padding(.top, 4)
                    }
                }
                .padding(.vertical)
                
                Button {
#if os(iOS)
                    presentFileSheet = true
#elseif os(macOS)
                    viewModel.openDocumentPicker(converter: converter, deckId: deckId, fileContent: $fileContent)
                    routerStore.push(route: .preview)
#endif
                } label: {
                    Label(
                        NSLocalizedString("csv_import_button", bundle: .module, comment: ""),
                        systemImage: "arrow.up"
                    )
                }
                .buttonStyle(.bordered)
                .tint(HBColor.actionColor)
                .foregroundColor(HBColor.actionColor)
                
                
            }
            .padding()
        }
        #if os(iOS)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .cancel) {
                    isPresenting = false
                } label: {
                    Text("cancel", bundle: .module)
                }
            }
        }
        #endif
        .navigationBarBackButtonHidden(true)
        .navigationTitle(Text("Importar Flashcards", bundle: .module))
    }
}
