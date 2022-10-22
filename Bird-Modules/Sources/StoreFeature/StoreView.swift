//
//  StoreView.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import SwiftUI
import HummingBird
import Models

struct StoreView: View {
    @StateObject private var viewModel: StoreViewModel = StoreViewModel()
    @State private var searchText = ""
    private var sortedDecks: [Deck] {
        viewModel.decks.sorted(using: viewModel.sortOrder)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Por Spixii")
                .font(.title3)
                .bold()
                .padding()
                 
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(sortedDecks) { deck in
                        PublicDeckView(color: deck.color,
                                       deckName: deck.name,
                                       icon: deck.icon,
                                       author: "Spixii",
                                       copies: 20)
                        .frame(width: 180, height: 210)
                        .cornerRadius(13)
                    }
                    .padding()
                }
            }
        }
        .onAppear(perform: viewModel.startup)
        .navigationTitle("Baralhos Públicos")
        .searchable(text: $viewModel.searchFieldContent, placement: .navigationBarDrawer(displayMode: .always))
        .viewBackgroundColor(HBColor.primaryBackground)
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StoreView()
        }
    }
}
