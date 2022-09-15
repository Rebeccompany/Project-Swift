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
    @Binding var cards: [CardViewModel]
    let cardBaseSize: CGSize = .init(width: 11, height: 18)
    
    
    var body: some View {
        GeometryReader { proxy in
            let cardSize = getCardSize(proxy.size)
            
            HStack {
                Spacer()
                ZStack {
                    ForEach(Array(zip($cards, cards.indices)), id: \.0.card.id) { $card, i in
                        FlashcardView(viewModel: $card, index: i)
                            .offset(y: getCardOffset(index: i))
                            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                            .zIndex(Double(i))
                    }
                }
                .padding(.bottom, 10 * Double(cards.count - 1))
                .frame(width: cardSize.width, height: cardSize.height, alignment: .center)
                Spacer()
            }
           
        }
    }
    
    private func getCardSize(_ geometrySize: CGSize) -> CGSize {

        var size: CGSize = .zero
        
        size.height = geometrySize.height
        size.width = (cardBaseSize.width/cardBaseSize.height)*size.height
        
        return size
    }
    
    private func getCardOffset(index: Int) -> Double {
        Double(index) * 10
    }
}

struct FlashcardDeckView_Previews: PreviewProvider {
    
    private struct Preview: View {
        @State
        private var cards: [CardViewModel] = [CardViewModel(card: FlashcardView_Previews.dummy, isFlipped: false) ]
        
        var body: some View {
            VStack {
                FlashcardDeckView(cards: $cards)
                    .padding()
                
                HStack {
                    Button {
                        withAnimation {
                            cards.insert(CardViewModel(card: FlashcardView_Previews.dummy, isFlipped: false), at: 0)
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
