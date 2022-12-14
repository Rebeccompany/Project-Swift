//
//  FlashcardCell.swift
//  
//
//  Created by Caroline Taus on 14/09/22.
//

import SwiftUI
import Models

public struct FlashcardCell: View {
    private var isFront: Bool
    private var action: () -> Void
    private var front: NSAttributedString
    private var back: NSAttributedString
    private var color: CollectionColor
    
    public init(card: Card, isFront: Bool = true, action: @escaping () -> Void) {
        self.action = action
        self.isFront = isFront
        self.front = card.front
        self.back = card.back
        self.color = card.color
    }
    
    public init(card: ExternalCard, isFront: Bool = true, action: @escaping () -> Void) {
        self.front = try! NSTextStorage(rtfData: card.front.data(using: .utf8)!)
        self.back = try! NSTextStorage(rtfData: card.back.data(using: .utf8)!)
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
                        .foregroundColor(color == .white ? .black : .white)
                    Spacer()
                }
                Spacer()
                #if os(iOS)
                TextViewRepresentable(text: isFront ? front : back)
                #elseif os(macOS)
                ScrollView {
                    Text(isFront ? AttributedString(front) : AttributedString(back))
                }
                #endif
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
