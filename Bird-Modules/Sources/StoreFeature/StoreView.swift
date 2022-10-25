//
//  StoreView.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import SwiftUI
import HummingBird
import Habitat
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
                 
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 220), spacing: 16, alignment: .top)], spacing: 16) {
                    ForEach(sortedDecks) { deck in
                        PublicDeckView(deck: deck,
                                       copies: 20,
                                       author: "Spixii")
                        .frame(width: 160, height: 210)
                        .cornerRadius(13)
                    }
                }
                .padding(.horizontal)
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
        HabitatPreview {
            NavigationStack {
                StoreView()
            }
        }
    }
}
