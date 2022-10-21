//
//  StoreView.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import SwiftUI
import HummingBird

struct StoreView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Por Spixii")
                .font(.title3)
                .bold()
                 
            PublicDeckView(color: .red, deckName: "Jogos de Switch", icon: .gamecontroller, author: "Spixii", copies: 30)
                .frame(width: 180, height: 210)
                .cornerRadius(13)
                .navigationTitle("Baralhos Públicos")
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                
        }
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
