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
    var color: CollectionColor
    var deckName: String
    var icon: String
    var author: String
    var copies: Int
    
    init(color: CollectionColor, deckName: String, icon: String, author: String, copies: Int) {
        self.color = color
        self.deckName = deckName
        self.icon = icon
        self.author = author
        self.copies = copies
    }
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 40))
                
            Text(deckName)
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
        .padding(10)
        .viewBackgroundColor(HBColor.color(for: color))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PublicDeckView(color: .red, deckName: "Jogos de Switch", icon: IconNames.gamecontroller.rawValue, author: "Spixii", copies: 20)
            .frame(width: 180, height: 220)
    }
}
