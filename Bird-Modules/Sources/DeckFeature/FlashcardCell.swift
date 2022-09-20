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
            .foregroundColor(.white)
            .padding(8)
            .frame(minHeight: 150)
            .background(HBColor.getHBColrFromCollectionColor(card.color))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 3)
            )
        }
    }
    
    private func cardText(_ content: AttributedString) -> AttributedString {
        var content = content
        content.swiftUI.font = .body
        content.swiftUI.foregroundColor = .white
        
        return content
    }
}

struct FlashcardCell_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardCell(card: Card(id: UUID(), front: "frentee", back: "tras", color: CollectionColor.lightPurple, datesLogs: DateLogs(), deckID: UUID(), woodpeckerCardInfo: WoodpeckerCardInfo(hasBeenPresented: true), history: [])) {}
    }
}
