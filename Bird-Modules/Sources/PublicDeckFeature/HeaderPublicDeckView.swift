//
//  HeaderPublicDeckView.swift
//  
//
//  Created by Rebecca Mello on 25/10/22.
//

import SwiftUI
import Models

struct HeaderPublicDeckView: View {
    var deck: ExternalDeck
    
    var body: some View {
        Image(systemName: deck.icon.rawValue)
            .font(.system(size: 40))
            .foregroundColor(.white)
            .padding()
            .background(
                Circle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
            )
        
        Text(deck.name)
            .font(.title2)
            .bold()
            .padding(.top, 20)
        
        Text(" ")
    }
}

struct HeaderPublicDeckView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderPublicDeckView(deck: ExternalDeck(id: "1", name: "Deck exemplo", description: "Uma descrição x", icon: .abc, color: .gray, category: .arts))
    }
}
