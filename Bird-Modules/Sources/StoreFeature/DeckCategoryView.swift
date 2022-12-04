//
//  DeckCategoryView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/12/22.
//

import SwiftUI
import Models

struct DeckCategoryView: View {
    
    let category: String
    
    var body: some View {
        List {
            ForEach(0..<100) { i in
                NavigationLink(value: deck) {
                    SearchDeckCell(deck: deck)
                }

            }
        }
        .listStyle(.plain)
        .navigationTitle(category)
        
    }
    
    var deck = ExternalDeck(id: "oi", name: "Some Deck", description: "A decription deck from somewhere", icon: .brain, color: .black, category: .stem, ownerId: "oi", ownerName: "gbrlCM", cardCount: 10)
}

struct DeckCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeckCategoryView(category: "Humanities")
        }
    }
}
