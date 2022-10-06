//
//  FlashcardTextEditorView.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//
//
import SwiftUI
import RichTextKit
import Combine

public struct FlashcardTextEditorView: View {
    @Binding private var cardText: String
    var color: Color
    var side: String
    
    
    @State var text = NSAttributedString(string: "")
    
    @Binding var context: RichTextContext

    
    public init(color: Color, side: String, cardText: Binding<String>, context: Binding<RichTextContext>) {
        self.color = color
        self.side = side
        self._cardText = cardText
        self._context = context
    }
    
    public var body: some View {
        VStack() {
            
            VStack(alignment: .leading) {
                Text(side)
                    .foregroundColor(.white)
                    .padding([.leading, .top])
                    .font(.system(size: 16))
                
                RichTextEditor(text: $text, context: context) {
                    $0.textContentInset = CGSize(width: 10, height: 20)
                }
                
                
                
                .scrollDisabled(true)
            }
            .background(color)
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white, lineWidth: 3)
            )
            
        }
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardTextEditorView(color: .blue, side: "Frente", cardText: .constant("Ola"), context: .constant(RichTextContext()))
            .environment(\.sizeCategory, .medium)
    }
}


