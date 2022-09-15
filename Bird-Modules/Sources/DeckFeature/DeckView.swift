//
//  DeckView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import HummingBird
import Models

struct DeckView: View {
    var decks: [Deck]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 180, maximum: 220), spacing: 24)], spacing: 24) {
                ForEach(decks) { deck in
                    DeckCell(info: DeckCellInfo(deck: deck))
                }
            }
        }
//        .searchable(text: $searchText)
        .navigationTitle("Todos")
//        .toolbar {
//            ToolbarItem {
//                Button {
//                    print("grid")
//                } label: {
//                    Image(systemName: "rectangle.grid.2x2")
//                        .foregroundColor(HBColor.actionColor)
//                }
//            }
//
//            ToolbarItem {
//                Button {
//                    print("editar")
//                } label: {
//                    EditButton()
//                        .foregroundColor(HBColor.actionColor)
//                }
//            }
//
//            ToolbarItem {
//                Button {
//                    print("novo deck")
//                } label: {
//                    Image(systemName: "plus")
//                        .foregroundColor(HBColor.actionColor)
//                }
//            }
//        }
        .padding(.horizontal, 12)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeckView(decks: [Deck(id: UUID.init(), name: "Baralho 1", icon: "flame", color: .otherPink, collectionsIds: [], cardsIds: [])])
                .previewDevice(PreviewDevice(stringLiteral: "iPhone 12"))
        }
    }
}
