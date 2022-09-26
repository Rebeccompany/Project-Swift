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
    var decks: [Deck]
    var editAction: (Deck) -> Void
    var deleteAction: (Deck) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 24, alignment: .top)], spacing: 24) {
                ForEach(decks) { deck in
                    NavigationLink(value: StudyRoute.deck(deck)) {
                        DeckCell(info: DeckCellInfo(deck: deck))
                            .frame(minHeight: 100)
                            .contextMenu {
                                Button {
                                    editAction(deck)
                                } label: {
                                    Label("Editar", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    deleteAction(deck)
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

struct DeckGridView_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationStack {
        DeckGridView(decks: [Deck(id: UUID(), name: "Baralho 1", icon: "flame", color: .otherPink, collectionId: nil, cardsIds: [])]) { _ in } deleteAction: { _ in }
            .previewDevice(PreviewDevice(stringLiteral: "iPhone 12"))
        //}
    }
}
