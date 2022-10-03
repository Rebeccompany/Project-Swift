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
    
    private var sortedDecks: [Deck] {
        viewModel.decks.sorted(using: viewModel.sortOrder)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 24, alignment: .top)], spacing: 24) {
                ForEach(sortedDecks) { deck in
                    NavigationLink(value: StudyRoute.deck(deck)) {
                        DeckCell(info: DeckCellInfo(deck: deck))
                            .buttonStyle(DeckCell.Style(color: deck.color))
                            .contextMenu {
                                Button {
                                    editAction(deck)
                                } label: {
                                    Label(NSLocalizedString("editar", bundle: .module, comment: ""), systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    try? viewModel.deleteDeck(deck)
                                } label: {
                                    Label(NSLocalizedString("deletar", bundle: .module, comment: ""), systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .animation(.linear, value: viewModel.sortOrder)
            .padding([.horizontal], 12)
            .padding(.top, 24)
        }
    }
}
