//
//  FlashcardCell.swift
//  
//
//  Created by Caroline Taus on 14/09/22.
//

import SwiftUI
import Models
import HummingBird
import Storage

struct FlashcardCell: View {
    var card: Card
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center) {
                HStack {
                    Text("Frente")
                        .font(.system(size: 15))
                    Spacer()
                }
                Spacer()
                Text(cardText(card.front))
                Spacer()
            }
        }.buttonStyle(Style(color: card.color))
    }
    
    private func cardText(_ content: AttributedString) -> AttributedString {
        var content = content
        content.swiftUI.font = .body
        content.swiftUI.foregroundColor = .white
        
        return content
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
        FlashcardCell(card: Card(id: UUID(), front: "frentee", back: "tras", color: CollectionColor.lightPurple, datesLogs: DateLogs(), deckID: UUID(), woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: true), history: [])) {}
    }
}
