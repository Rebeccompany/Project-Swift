//
//  FlashcardTextEditorViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 31/10/22.
//

import SwiftUI
import RichTextKit
import Combine
import PhotosUI
import Utils

#if os(macOS)
public struct FlashcardTextEditorViewMacOS: View {
    var color: Color
    var side: String
    var isFront: Bool
    
    @State private var isPhotoPickerPresented = false
    @State private var photoSelection: PhotosPickerItem?
    @Binding private var text: NSAttributedString
    
    @ObservedObject private var context: RichTextContext

    public init(text: Binding<NSAttributedString>, color: Color, side: String, context: RichTextContext, isFront: Bool) {
        self._text = text
        self.color = color
        self.side = side
        self.context = context
        self.isFront = isFront
    }
    
    public var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(side)
                    .foregroundColor(color == HBColor.collectionWhite ? .black : .white)
                    .padding([.leading, .top])
                    .font(.system(size: 16))
                
                RichTextEditor(text: $text, context: context) {
                    $0.textContentInset = CGSize(width: 10, height: 20)
                }
            }
        }
        .onAppear {
            if text.string.isEmpty {
                text = NSAttributedString(string: "", attributes: [.foregroundColor: NSColor.black])
            }
            context.shouldUpdateTextField()
            context.foregroundColorBinding.wrappedValue = .black
        }
        .background {
            if isFront {
                SpixiiShapeFront()
                    .foregroundColor(color)
            } else {
                SpixiiShapeBack()
                    .foregroundColor(color)
                    .brightness(0.04)
            }
        }
        .background {
            if isFront {
                color.brightness(0.04)
            } else {
                color
            }
        }
        .cornerRadius(16)
       
    }
    
    func text(for fontSize: CGFloat) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct FlashcardTextEditorViewMacOS_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardTextEditorViewMacOS(text: .constant(NSAttributedString("")), color: .blue, side: "Frente", context: RichTextContext(), isFront: true)
            .environment(\.sizeCategory, .medium)
    }
}
#endif
