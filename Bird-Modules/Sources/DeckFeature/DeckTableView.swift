//
//  DeckTableView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import Models

struct DeckTableView: View {
    var decks: [Deck]
    
    var body: some View {
        Table(decks) {
            TableColumn("Ítem do Baralho") { deck in
                Image(systemName: deck.icon)
            }
            
            TableColumn("Nome") { deck in
                Text(deck.name)
                    .foregroundColor(.black)
            }
            
            TableColumn("Flashcards") { deck in
                Text("\(deck.cardsIds.count)")
                    .foregroundColor(.black)
            }
//            
//            TableColumn("Último Acesso") { deck in
//                Text(deck.datesLogs.lastAccess)
//            }
        }
    }
}

struct DeckTableView_Previews: PreviewProvider {
    static var previews: some View {
        DeckTableView(decks: [Deck(id: UUID.init(), name: "Nome do Baralho 1", icon: "flame", color: .otherPink, collectionsIds: [], cardsIds: [])])
    }
}
