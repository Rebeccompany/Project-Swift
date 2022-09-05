//
//  FlashcardDeckView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 05/09/22.
//

import SwiftUI
import Models
import HummingBird

struct FlashcardDeckView: View {

    var cards: (first: Card, second: Card)
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                ZStack(alignment: .top) {
                    FlashcardView(card: cards.second, backgroundColor: HBColor.collectionDarkPurple)
                        .scaleEffect(0.97)
                    FlashcardView(card: cards.first, backgroundColor: HBColor.collectionGreen)
                        .offset(y: proxy.size.height * 0.04)
                }
                .padding(.bottom, proxy.size.height * 0.04)
            }
            .padding()
            
            Text("oi")
        }
        
    }
}

struct FlashcardDeckView_Previews: PreviewProvider {
    static var dummy: (first: Card, second: Card) {
        (first: FlashcardView_Previews.dummy, second: FlashcardView_Previews.dummy)
    }
    
    static var previews: some View {
        FlashcardDeckView(cards: dummy)
    }
}
