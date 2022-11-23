//
//  FlashcardCell.swift
//  
//
//  Created by Caroline Taus on 14/09/22.
//

import SwiftUI
import Models

public struct FlashcardCell: View {
    var card: Card
    var isFront: Bool
    var action: () -> Void
    
    public init(card: Card, isFront: Bool = true, action: @escaping () -> Void) {
        self.card = card
        self.action = action
        self.isFront = isFront
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(alignment: .center) {
                HStack {
                    Text(isFront ? "frente" : "verso", bundle: .module)
                        .font(.system(size: 15))
                        .foregroundColor(card.color == .white ? .black : .white)
                    Spacer()
                }
                Spacer()
                TextViewRepresentable(text: isFront ? card.front.attributedString : card.back.attributedString)
                Spacer()
            }
        }
        .buttonStyle(Style(color: card.color))
    }
    
    private struct Style: ButtonStyle {
        
        private var color: CollectionColor
        
        init(color: CollectionColor) {
            self.color = color
        }
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
            .foregroundColor(.white)
            .padding()
            .background {
                SpixiiShapeFront()
                    .foregroundColor(HBColor.color(for: color))
            }
            .background {
                HBColor.color(for: color).brightness(0.04)
            }
            .cornerRadius(16)
        }
    }
}

struct FlashcardCell_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardCell(card: Card(id: UUID(), front: NSAttributedString(string: "frentee"), back: NSAttributedString(string: "tras"), color: CollectionColor.lightPurple, datesLogs: DateLogs(), deckID: UUID(), woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: true), history: [])) {}
    }
}
