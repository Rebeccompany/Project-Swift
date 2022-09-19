//
//  DeckTableView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import Models
import HummingBird

struct DeckTableView: View {
    var decks: [Deck]
    @Binding private var sortOrder: [KeyPathComparator<Deck>]
    @Binding private var selection: Set<Deck.ID>
    
    init(decks: [Deck],
         sortOrder: Binding<[KeyPathComparator<Deck>]>,
         selection: Binding<Set<Deck.ID>>
    ) {
        self.decks = decks
        self._sortOrder = sortOrder
        self._selection = selection
    }
    
    private var sortedDecks: [Deck] {
        decks.sorted(using: sortOrder)
    }
    
    var body: some View {
        Table(sortedDecks, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Nome", value: \.name) { deck in
                NavigationLink(value: StudyRoute.deck(deck)) {
                    HStack {
                        Image(systemName: deck.icon)
                            .foregroundColor(HBColor.getHBColrFromCollectionColor(deck.color))
                            .background(
                                Circle()
                                    .fill(HBColor.getHBColrFromCollectionColor(deck.color).opacity(0.2))
                                    .frame(width: 30, height: 30)
                            )
                            .padding(.trailing, 8)
                        Text(deck.name)
                    }
                    .padding(.leading, 4)
                }
            }
            TableColumn("Flashcards", value: \.cardCount) { deck in
                Text("\(deck.cardCount) flashcards")
            }
            TableColumn("Último Acesso", value: \.datesLogs.lastAccess) { deck in
                Text(deck.datesLogs.lastAccess, style: .date)
            }
        }
        .animation(.linear, value: sortOrder)
    }
}

struct DeckTableView_Previews: PreviewProvider {
    static var previews: some View {
        DeckTableView(decks: [Deck(id: UUID.init(), name: "Nome do Baralho 1", icon: "flame", color: .otherPink, collectionsIds: [], cardsIds: []), Deck(id: UUID.init(), name: "Nome do Baralho 2", icon: "flame", color: .otherPink, collectionsIds: [], cardsIds: [UUID.init()])], sortOrder: .constant([.init(\.name)]), selection: .constant(.init()))
    }
}
