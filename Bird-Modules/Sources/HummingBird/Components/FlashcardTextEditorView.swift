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
import PhotosUI

public struct FlashcardTextEditorView: View {
    var color: Color
    var side: String
    
    @State private var isPhotoPickerPresented = false
    @State private var photoSelection: PhotosPickerItem?
    @Binding private var text: NSAttributedString
    
    @ObservedObject private var context: RichTextContext

    public init(text: Binding<NSAttributedString>, color: Color, side: String, context: RichTextContext) {
        self._text = text
        self.color = color
        self.side = side
        self.context = context
    }
    
    public var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(side)
                    .foregroundColor(.white)
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
        .background(color)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white, lineWidth: 3)
        )
        .cornerRadius(16)
        .photosPicker(isPresented: $isPhotoPickerPresented,
                      selection: $photoSelection,
                      matching: .all(of: [.images, .not(.livePhotos)]))
        .onChange(of: photoSelection) { newValue in
            Task {
                await updateFromPhotoSelection(newValue)
            }
        }
        .onAppear {
            context.foregroundColor = ColorRepresentable.black
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
                
                Button { context.isBold.toggle() } label: {
                    Image.richTextStyleBold
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.bordered)
                .tint(context.isBold ? HBColor.actionColor : nil)
                
                Button { context.isUnderlined.toggle() } label: {
                    Image.richTextStyleUnderline
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.bordered)
                .tint(context.isUnderlined ? HBColor.actionColor : nil)
//                Button {
//                    isPhotoPickerPresented = true
//                } label: {
//                    Image(systemName: "photo.on.rectangle")
//                        .frame(width: 18, height: 18)
//                }
//                .frame(width: 32, height: 32)
//                .buttonStyle(.bordered)
//                .padding(.horizontal, 4)
                alignmentMenu
                HBColorPicker(selection: context.foregroundColorBinding) {
                    Image(systemName: "character")
                        .font(.system(size: 18))
                }
                    .buttonStyle(.bordered)
                    
                HBColorPicker(selection: context.backgroundColorBinding) {
                    Image(systemName: "highlighter")
                        .font(.system(size: 14))
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
            FontSizePicker(selection: size)
                .labelsHidden()
            Button {
                context.incrementFontSize()
            } label: {
                Image(systemName: "plus")
                    .frame(width: 10, height: 10)
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardTextEditorView(text: .constant(NSAttributedString("")), color: .blue, side: "Frente", context: RichTextContext())
            .environment(\.sizeCategory, .medium)
    }
}

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
