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
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.decks) { section in
                    PublicSection(section: section)
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
