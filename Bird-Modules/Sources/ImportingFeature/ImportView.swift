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
    @State private var showAlert: Bool = false
    @StateObject private var viewModel = ImportViewModel()
    @Binding private var isPresenting: Bool
    
    #if os(macOS)
    private let data: ImportWindowData
    
    public init(data: ImportWindowData, isPresenting: Binding<Bool>) {
        self.data = data
        self._isPresenting = isPresenting
    }
    #elseif os(iOS)
    
    private let deck: Deck
    
    public init(deck: Deck, isPresenting: Binding<Bool>) {
        self.deck = deck
        self._isPresenting = isPresenting
    }
    #endif
    
    public var body: some View {
        Router(path: $path) {
            #if os(iOS)
            ImportSelectionView(isPresenting: $isPresenting, presentFileSheet: $presentFileSheet)
                .sheet(isPresented: $presentFileSheet) {
                    DocumentPicker(fileContent: $cards, deckId: deck.id) {
                        isPresenting = false
                    }
                }
            #elseif os(macOS)
            ImportSelectionView(fileContent: $cards, deckId: data.deck.id)
            #endif
        } destination: { (route: ImportRoute) in
            switch route {
            case .preview:
                #if os(iOS)
                ReviewImportView(isPresentingSheet: $isPresenting, cards: $cards, showAlert: $showAlert, deck: deck)
                #elseif os(macOS)
                ReviewImportView(isPresentingSheet: $isPresenting, cards: $cards, showAlert: $showAlert, deck: data.deck)
                #endif
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
        #if os(macOS)
        ImportView(data: ImportWindowData(deck: Deck(id: UUID(), name: "Deck0", icon: IconNames.abc.rawValue, color: CollectionColor.red, datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0), lastEdit: Date(timeIntervalSince1970: 0), createdAt: Date(timeIntervalSince1970: 0)), collectionId: nil, cardsIds: [], spacedRepetitionConfig: .init(maxLearningCards: 20, maxReviewingCards: 200, numberOfSteps: 4), category: DeckCategory.arts, storeId: nil, description: "" )), isPresenting: .constant(true))
        #endif
    }
}
