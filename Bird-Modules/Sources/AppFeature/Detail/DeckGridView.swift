//
//  DeckGridView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import HummingBird
import Models

struct DeckGridView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    var editAction: (Deck) -> Void
    @State private var shouldDisplayAlert = false
    @State private var deckToBeDeleted: Deck?
    
    private var sortedDecks: [Deck] {
        viewModel.decks.sorted(using: viewModel.sortOrder)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 188), spacing: 24, alignment: .top)], spacing: 24) {
                ForEach(sortedDecks) { deck in
                    NavigationLink(value: StudyRoute.deck(deck)) {
                        DeckCell(info: DeckCellInfo(deck: deck))
                            .contextMenu {
                                Button {
                                    editAction(deck)
                                } label: {
                                    Label(NSLocalizedString("editar", bundle: .module, comment: ""), systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    shouldDisplayAlert = true
                                    deckToBeDeleted = deck
                                    
                                } label: {
                                    Label(NSLocalizedString("deletar", bundle: .module, comment: ""), systemImage: "trash")
                                }
                            }
                    }
                    #if os(iOS)
                    .hoverEffect()
                    .padding(2)
                    #endif
                    .buttonStyle(DeckCell.Style(color: deck.color))
                    .confirmationDialog("Are you sure?", isPresented: $shouldDisplayAlert) {
                        Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                            guard let deckToBeDeleted else { return }
                            try? viewModel.deleteDeck(deckToBeDeleted)
                        }
                    } message: {
                        Text(NSLocalizedString("alert_confirmacao_deletar", bundle: .module, comment: ""))
                    }
                }
            }
            .animation(.linear, value: viewModel.sortOrder)
            .padding([.horizontal], 12)
            .padding(.top, 24)
        }
        

    }
}
