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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 24)], spacing: 24) {
                ForEach(decks) { deck in
                    NavigationLink(value: StudyRoute.deck(deck)) {
                        DeckCell(info: DeckCellInfo(deck: deck))
                            .frame(minHeight: 100)
                    }
                }
            }
            .padding([.horizontal, .top], 12)
        }
    }
}

struct DeckGridView_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationStack {
        DeckGridView(decks: [Deck(id: UUID(), name: "Baralho 1", icon: "flame", color: .otherPink, collectionId: nil, cardsIds: [])])
                .previewDevice(PreviewDevice(stringLiteral: "iPhone 12"))
        //}
    }
}
