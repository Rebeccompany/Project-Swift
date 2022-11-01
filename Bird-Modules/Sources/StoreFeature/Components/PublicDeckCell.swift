//
//  PublicDeckView.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import SwiftUI
import Models
import HummingBird

struct PublicDeckCell: View {
    var deck: ExternalDeck
    var numberOfCopies: Int
    var author: String
    
    init(deck: ExternalDeck, numberOfCopies: Int, author: String) {
        self.deck = deck
        self.numberOfCopies = numberOfCopies
        self.author = author
    }
    
    var body: some View {
        VStack {
            Image(systemName: deck.icon.rawValue)
                .foregroundColor(.white)
                .font(.system(size: 40))
                .fontWeight(.regular)
                
            Text(deck.name)
                .bold()
                .padding(4)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(.system(size: 20))
            
            HStack {
                Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                Text(String(numberOfCopies))
                    .foregroundColor(.white)
                    .bold()
            }
            Text(author)
                .foregroundColor(.white)
        }
        .padding(8)
        .cornerRadius(8)
        .viewBackgroundColor(HBColor.color(for: deck.color))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PublicDeckCell(deck: ExternalDeck(id: "1", name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem), numberOfCopies: 20, author: "BAHIAAAAA")
    }
}
