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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 24, alignment: .top)], spacing: 24) {
                ForEach(viewModel.decks) { deck in
                    NavigationLink(value: StudyRoute.deck(deck)) {
                        DeckCell(info: DeckCellInfo(deck: deck))
                            .contextMenu {
                                Button {
                                    editAction(deck)
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    try? viewModel.deleteDeck(deck)
                                } label: {
                                    Label("Deletar", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .padding([.horizontal], 12)
            .padding(.top, 24)
        }
    }
}
