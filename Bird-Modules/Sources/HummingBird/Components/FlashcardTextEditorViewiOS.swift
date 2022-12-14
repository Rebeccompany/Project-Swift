//
//  FlashcardTextEditorViewiOS .swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//
//

import SwiftUI
import RichTextKit
import Combine
import PhotosUI
import Utils

#if os(iOS)
public struct FlashcardTextEditorViewiOS: View {
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
            
            if context.isEditingText {
                styleStack
                    .padding()
                    .background(.thinMaterial)
            }
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
        .onAppear {
            context.foregroundColor = ColorRepresentable.white
            context.shouldUpdateTextField()
        }
    }

    @ViewBuilder
    private var styleStack: some View {
        VStack(alignment: .center) {
            HStack(alignment: .top, spacing: 16) {
                Button { context.isItalic.toggle() } label: {
                    Image.richTextStyleItalic
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.bordered)
                .tint(context.isItalic ? HBColor.actionColor : nil)
                .keyboardShortcut("i", modifiers: .command)
                
                Button { context.isBold.toggle() } label: {
                    Image.richTextStyleBold
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.bordered)
                .tint(context.isBold ? HBColor.actionColor : nil)
                .keyboardShortcut("b", modifiers: .command)
                
                Button { context.isUnderlined.toggle() } label: {
                    Image.richTextStyleUnderline
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.bordered)
                .tint(context.isUnderlined ? HBColor.actionColor : nil)
                .keyboardShortcut("u", modifiers: .command)
                alignmentMenu
                HBColorPicker {  
                    Image(systemName: "character")
                        .font(.system(size: 18))
                } onColorSelected: { color in
                    context.foregroundColorBinding.wrappedValue = color
                }
                    .buttonStyle(.bordered)
                    
                HBColorPicker {
                    Image(systemName: "highlighter")
                        .font(.system(size: 14))
                } onColorSelected: { color in
                    context.backgroundColorBinding.wrappedValue = color
                }
                    .buttonStyle(.bordered)
            }
            HStack {
                Spacer()
                sizeTools(for: $context.fontSize)
                    .frame(width: 115)
                    .padding(.horizontal, 4)
                    .background(.regularMaterial)
                    .cornerRadius(8)
                Spacer()
            }
            
        }
    }
    
    @ViewBuilder
    private var alignmentMenu: some View {
        Menu {
            ForEach(RichTextAlignment.allCases) { alignment in
                Button {
                    context.alignment = alignment
                } label: {
                    Label {
                        Text(alignment.rawValue)
                    } icon: {
                        alignment.icon
                    }
                }
            }
            
        } label: {
            context.alignment.icon
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
    }
    
    private func updateFromPhotoSelection(_ photoPickerItem: PhotosPickerItem?) async {
        if let selectedPhotoData = try? await photoPickerItem?.loadTransferable(type: Data.self),
           let rawImageData = UIImage(data: selectedPhotoData)?.aspectFittedToHeight(150),
           let compressedImage = rawImageData.jpegData(compressionQuality: 0.5),
           let image = ImageRepresentable(data: compressedImage) {
            let lowerBound = context.selectedRange.lowerBound
            context.pasteImage(image, at: lowerBound)
        }
    }
    
    func sizeTools(for size: Binding<CGFloat>) -> some View {
        HStack {
            Button {
                context.decrementFontSize()
            } label: {
                Image(systemName: "minus")
                    .frame(width: 10, height: 10)
            }
            .keyboardShortcut("-", modifiers: .command)
            FontSizePicker(selection: size)
                .labelsHidden()
                .frame(minWidth: 50)
            Button {
                context.incrementFontSize()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 10, height: 10)
            }
            .keyboardShortcut("+", modifiers: .command)
        }
    }
    
    func text(for fontSize: CGFloat) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct FlashcardTextEditorViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardTextEditorViewiOS(text: .constant(NSAttributedString("")), color: .blue, side: "Frente", context: RichTextContext(), isFront: true)
            .environment(\.sizeCategory, .medium)
    }
}
#endif
