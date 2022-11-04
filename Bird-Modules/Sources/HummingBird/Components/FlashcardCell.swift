//
//  FlashcardCell.swift
//  
//
//  Created by Caroline Taus on 14/09/22.
//

import SwiftUI
import Models

public struct FlashcardCell: View {
    //private var card: Card
    private var isFront: Bool
    private var action: () -> Void
    private var front: NSAttributedString
    private var back: NSAttributedString
    private var color: CollectionColor
    
    public init(card: Card, isFront: Bool = true, action: @escaping () -> Void) {
        //self.card = card
        self.action = action
        self.isFront = isFront
        self.front = card.front
        self.back = card.back
        self.color = card.color
    }
    
    public init(card: ExternalCard, isFront: Bool = true, action: @escaping () -> Void) {
        self.front = NSAttributedString(string: card.front)
        self.back = NSAttributedString(string: card.back)
        self.isFront = isFront
        self.action = action
        self.color = card.color
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(alignment: .center) {
                HStack {
                    Text(isFront ? "frente" : "verso", bundle: .module)
                        .font(.system(size: 15))
                    Spacer()
                }
                Spacer()
                TextViewRepresentable(text: isFront ? front : back)
                Spacer()
            }
        }
        .buttonStyle(Style(color: color))
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
            .background(HBColor.color(for: color))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 3)
            )
        }
    }
}

struct FlashcardCell_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardCell(card: Card(id: UUID(), front: NSAttributedString(string: "frentee"), back: NSAttributedString(string: "tras"), color: CollectionColor.lightPurple, datesLogs: DateLogs(), deckID: UUID(), woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: true), history: [])) {}
    }
}
