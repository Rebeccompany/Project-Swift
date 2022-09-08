//
//  DeckView.swift
//  
//
//  Created by Marcos Chevis on 30/08/22.
//

import Foundation
import SwiftUI
import Models

struct DeckView: View {
    
    var body: some View {
        List {
            
        }
        .navigationTitle(Text("oi").foregroundColor(.red))
    }
}

final class DeckViewModel: ObservableObject {
    @Published var deck: Deck
    
    init(deck: Deck) {
        self.deck = deck
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeckView()
        }
    }
}
