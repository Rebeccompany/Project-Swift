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
    let deck: ExternalDeck
    
    init(deck: ExternalDeck) {
        self.deck = deck
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
                Text(String(deck.cardCount))
                    .foregroundColor(.white)
                    .bold()
            }
            Text(deck.ownerName)
                .foregroundColor(.white)
        }
        .padding(8)
        .cornerRadius(8)
        .viewBackgroundColor(HBColor.color(for: deck.color))
    }
}

struct PublicDeckCell_Previews: PreviewProvider {
    static var previews: some View {
        PublicDeckCell(deck: ExternalDeck(id: "1", name: "Stem 1", description: "Stem Desc", icon: .chart, color: .red, category: .stem, ownerId: "id", ownerName: "name", cardCount: 3))
    }
}
