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
        GeometryReader { _ in
            ZStack(alignment: .top) {
                ForEach(Array(zip(cards, cards.indices)), id: \.0.id) { card, i in
                    FlashcardView(card: card)
                        .offset(y: getCardOffset(index: i))
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                        .zIndex(Double(i))
                }
            }
            .padding(.bottom, 10 * Double(cards.count - 1))
        }
    }
    
    private func getCardOffset(index: Int) -> Double {
        Double(index) * 10
    }
}

struct FlashcardDeckView_Previews: PreviewProvider {
    
    private struct Preview: View {
        @State
        private var cards: [Card] = [FlashcardView_Previews.dummy]
        
        var body: some View {
            VStack {
                FlashcardDeckView(cards: cards)
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
                    
                    Button {
                        withAnimation {
                            cards.shuffle()
                        }
                        
                    } label: {
                        Text("shuffle")
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
