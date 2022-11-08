//
//  ImportView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/09/22.
//

import SwiftUI
import Models
import Flock
import Storage
import HummingBird

public struct ImportView: View {
    @State private var path: NavigationPath = .init()
    @State private var cards: [Card] = []
    @State private var presentFileSheet = false
    @StateObject private var viewModel = ImportViewModel()
    @Binding private var isPresenting: Bool
    private let deck: Deck
    
    public init(deck: Deck, isPresenting: Binding<Bool>) {
        self.deck = deck
        self._isPresenting = isPresenting
    }
    
    public var body: some View {
        Router(path: $path) {
            ImportSelectionView(isPresenting: $isPresenting, presentFileSheet: $presentFileSheet)
                .sheet(isPresented: $presentFileSheet) {
                    DocumentPicker(fileContent: $cards, deckId: deck.id) {
                        isPresenting = false
                    }
                }
        } destination: { (route: ImportRoute) in
            switch route {
            case .preview:
                ReviewImportView(isPresentingSheet: $isPresenting, cards: $cards, deck: deck)
            }
        }
        .onChange(of: presentFileSheet) { newValue in
            if !newValue {
                path.append(ImportRoute.preview)
            }
        }
        .environmentObject(viewModel)

    }
}

struct ImportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportView(deck: Deck(id: UUID(), name: "Deck Nome", icon: IconNames.atom.rawValue, color: CollectionColor.red, collectionId: UUID(), cardsIds: [], category: .humanities, storeId: nil), isPresenting: .constant(true))
    }
}
