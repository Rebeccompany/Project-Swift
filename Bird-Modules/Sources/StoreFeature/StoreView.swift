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
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.decks.keys.map {$0}, id: \.self) { (key: DeckCategory) in
                    Section("\(key.rawValue)") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 24, alignment: .top)]) {
                            ForEach(viewModel.decks[key] ?? []) { deck in
                                PublicDeckView(deck: deck, copies: 10, author: "Spixii")
                            }
                            .cornerRadius(8)
                        }
                    }
                    .bold()
                    .padding([.bottom, .leading, .trailing], 12)
                }
            }
        }
        .onAppear(perform: viewModel.startup)
        .navigationTitle("Baralhos Públicos")
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
