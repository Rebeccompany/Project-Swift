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
            context.foregroundColor = ColorRepresentable.white
            context.shouldUpdateTextField()
        }
    }
    
    private func updateFromPhotoSelection(_ photoPickerItem: PhotosPickerItem?) async {
        if let selectedPhotoData = try? await photoPickerItem?.loadTransferable(type: Data.self),
           let rawImageData = NSImage(data: selectedPhotoData),//.aspectFittedToHeight(150),
           let compressedImage = rawImageData.jpegData(compressionQuality: 0.5),
           let image = ImageRepresentable(data: compressedImage) {
            let lowerBound = context.selectedRange.lowerBound
            context.pasteImage(image, at: lowerBound)
        }
    }
    
    func text(for fontSize: CGFloat) -> some View {
        Text("\(Int(fontSize))")
            .fixedSize(horizontal: true, vertical: false)
    }
}

struct FlashcardTextEditorViewMacOS_Previews: PreviewProvider {
    static var previews: some View {
        FlashcardTextEditorViewMacOS(text: .constant(NSAttributedString("")), color: .blue, side: "Frente", context: RichTextContext())
            .environment(\.sizeCategory, .medium)
    }
}
#endif
