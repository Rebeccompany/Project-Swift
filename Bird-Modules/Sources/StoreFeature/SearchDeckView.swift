//
//  SearchDeckView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 01/12/22.
//

import SwiftUI
import Models
import HummingBird

struct SearchDeckView: View {
    
    var body: some View {
        List {
            ForEach(0..<100) { i in
                HStack {
                    Image(systemName: IconNames.allCases.randomElement()!.rawValue)
                        .foregroundColor(HBColor.color(for: CollectionColor.allCases.filter {$0 != .white }.randomElement()!))
                        .font(.subheadline)
                        .frame(width: 30, height: 30, alignment: .center)
                    VStack(alignment: .leading) {
                        Text(deck.name)
                            .font(.headline)
                        Text(deck.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        HStack {
                            Text("made by \(deck.ownerName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("\(deck.cardCount) Cards")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Label("Search", systemImage: "magnifyingglass")
                    TextField("Search", text: .constant(""))
                }
            }
        }
    }
    
    var deck = ExternalDeck(id: "oi", name: "Some Deck", description: "A decription deck from somewhere", icon: .brain, color: .black, category: .stem, ownerId: "oi", ownerName: "gbrlCM", cardCount: 10)
}

struct SearchDeckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SearchDeckView()
        }
    }
}
