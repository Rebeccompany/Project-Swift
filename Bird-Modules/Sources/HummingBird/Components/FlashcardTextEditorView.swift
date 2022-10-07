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
    var color: Color
    var side: String
    
    
    @State private var text = NSAttributedString(string: "")
    
    @ObservedObject private var context: RichTextContext

    
    public init(color: Color, side: String, context: RichTextContext) {
        self.color = color
        self.side = side
        self.context = context
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(side)
                    .foregroundColor(.white)
                    .padding([.leading, .top])
                    .font(.system(size: 16))
                
                RichTextEditor(text: $text, context: context) {
                    $0.textContentInset = CGSize(width: 10, height: 20)
                }
            }
            .background(color)
            .clipShape(
                RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white, lineWidth: 3)
            )
            
            if context.isEditingText {
                HStack {
                    Button { context.isItalic.toggle() } label: {
                        Image.richTextStyleItalic
                            .frame(height: 18)
                    }
                    .frame(width: 32, height: 32)
                    .buttonStyle(.bordered)
                    .tint(context.isItalic ? HBColor.actionColor : nil)
                    .padding(.horizontal, 4)
                    
                    Button { context.isBold.toggle() } label: {
                        Image.richTextStyleBold
                            .frame(height: 18)
                    }
                    .frame(width: 32, height: 32)
                    .buttonStyle(.bordered)
                    .tint(context.isBold ? HBColor.actionColor : nil)
                    .padding(.horizontal, 4)
                    
                    Button { context.isUnderlined.toggle() } label: {
                        Image.richTextStyleUnderline
                            .frame(height: 18)
                    }
                    .frame(width: 32, height: 32)
                    .buttonStyle(.bordered)
                    .tint(context.isUnderlined ? HBColor.actionColor : nil)
                    .padding(.horizontal, 4)
                    ColorPicker("Text", selection: context.foregroundColorBinding)
                    ColorPicker("Background", selection: context.backgroundColorBinding)
                    
                    Menu {
                        
                    } label: {
                        circle
                            .frame(width: 32, height: 32)
                    }
                    .frame(width: 32, height: 32)
                    .padding(.horizontal, 4)

                    Spacer()
                }
                .padding()
                .background(.thinMaterial)
                
            }
            
        }.cornerRadius(16)
        
    }
    
    @ViewBuilder
    private var circle: some View {
        Circle()
            .fill(
                AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .cyan, .purple], center: .center)
            )
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardTextEditorView(color: .blue, side: "Frente", context: RichTextContext())
            .environment(\.sizeCategory, .medium)
    }
}
