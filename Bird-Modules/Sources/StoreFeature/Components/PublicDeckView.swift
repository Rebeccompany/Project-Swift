//
//  PublicDeckView.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import SwiftUI
import Models
import HummingBird

struct PublicDeckView: View {
    var deck: ExternalDeck
    var copies: Int
    var author: String
    
    init(deck: ExternalDeck, copies: Int, author: String) {
        self.deck = deck
        self.copies = copies
        self.author = author
    }
    
    var body: some View {
        VStack {
            Image(systemName: deck.icon.rawValue)
                .foregroundColor(.white)
                .font(.system(size: 40))
                
            Text(deck.name)
                .bold()
                .padding(10)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.system(size: 20))
            HStack {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                    .foregroundColor(.white)
                Text(String(copies))
                    .foregroundColor(.white)
                    .bold()
            }
            Text(author)
                .padding(1)
                .foregroundColor(.white)
        }
        .cornerRadius(8)
        .padding(10)
        .viewBackgroundColor(HBColor.color(for: deck.color))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Text("oi")
    }
}
