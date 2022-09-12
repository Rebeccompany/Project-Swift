//
//  FlashcardTextEditorView.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//

import SwiftUI
import UIKit

struct FlashcardTextEditorView: View {
    @Binding private var cardText: String
    var color: Color
    var side: String
    
    init(color: Color, side: String, cardText: Binding<String>) {
        UITextView.appearance().backgroundColor = .clear
        self.color = color
        self.side = side
        self._cardText = cardText
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(side)
                .foregroundColor(.white)
                .padding()
                .font(.system(size: 16))
            
            TextEditor(text: $cardText)
                .foregroundColor(.white)
                .padding()
        }
        .background(color)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white, lineWidth: 3)
        )
        .padding()
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardTextEditorView(color: .blue, side: "Frente", cardText: .constant("Ola"))
            .environment(\.sizeCategory, .medium)
    }
}
