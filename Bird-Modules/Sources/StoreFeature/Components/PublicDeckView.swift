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
    var color: Color
    var deckName: String
    var icon: IconNames
    var author: String
    var copies: Int
    
    public init(color: Color, deckName: String, icon: IconNames, author: String, copies: Int) {
        self.color = color
        self.deckName = deckName
        self.icon = icon
        self.author = author
        self.copies = copies
    }
    
    var body: some View {
        VStack {
            Image(systemName: icon.rawValue)
                .resizable()
                .foregroundColor(.white)
                .frame(width: 70, height: 50)
                
            Text(deckName)
                .bold()
                .padding()
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
        .viewBackgroundColor(color)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PublicDeckView(color: .red, deckName: "Jogos de Switch", icon: .gamecontroller, author: "Spixii", copies: 20)
    }
}
