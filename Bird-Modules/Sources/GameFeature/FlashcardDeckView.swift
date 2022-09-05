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
    var cards: [Card]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ForEach(Array(zip(cards, cards.indices)), id: \.0.id) { card, i in
                    FlashcardView(card: card, backgroundColor: HBColor.collectionDarkPurple)
                        .offset(y: getCardOffset(index: i))
                        .transition(.move(edge: .trailing))
                        .zIndex(Double(i))
                }
            }
            .padding(.bottom, 10 * CGFloat(cards.count-1))
        }
    }
    
    private func getCardOffset(index: Int) -> CGFloat {
        return  CGFloat(index) * 10
    }
}

struct FlashcardDeckView_Previews: PreviewProvider {
    
    private struct Preview: View {
        @State
        var cards: [Card] = [FlashcardView_Previews.dummy]
        
        var body: some View {
            VStack {
                FlashcardDeckView(cards: cards)
                    .background(Color.red)
                    .padding()
                
                HStack {
                    Button {
                        withAnimation {
                            cards.insert(FlashcardView_Previews.dummy, at: 0)
                        }
                        
                    } label: {
                        Text("add")
                    }
                    
                    Button {
                        withAnimation {
                            cards.removeLast(1)
                        }
                        
                    } label: {
                        Text("remove")
                    }
                }
            }
            
        }
    }
    
    static var previews: some View {
        ZStack {
            HBColor.primaryBackground.ignoresSafeArea()
            Preview()
        }
    }
}
