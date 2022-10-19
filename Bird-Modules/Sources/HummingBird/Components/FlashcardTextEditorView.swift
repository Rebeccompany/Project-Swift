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
                VStack {
                    HStack {
                        Button { context.isItalic.toggle() } label: {
                            Image.richTextStyleItalic
                                .frame(width: 18, height: 18)
                        }
                        .frame(width: 32, height: 32)
                        .buttonStyle(.bordered)
                        .tint(context.isItalic ? HBColor.actionColor : nil)
                        .padding(.horizontal, 4)
                        
                        Button { context.isBold.toggle() } label: {
                            Image.richTextStyleBold
                                .frame(width: 18, height: 18)
                        }
                        .frame(width: 32, height: 32)
                        .buttonStyle(.bordered)
                        .tint(context.isBold ? HBColor.actionColor : nil)
                        .padding(.horizontal, 4)
                        
                        Button { context.isUnderlined.toggle() } label: {
                            Image.richTextStyleUnderline
                                .frame(width: 18, height: 18)
                        }
                        .frame(width: 32, height: 32)
                        .buttonStyle(.bordered)
                        .tint(context.isUnderlined ? HBColor.actionColor : nil)
                        .padding(.horizontal, 4)
                        
                        Button {
                            isPhotoPickerPresented = true
                        } label: {
                            Image(systemName: "photo.on.rectangle")
                                .frame(width: 18, height: 18)
                        }
                        .frame(width: 32, height: 32)
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 4)
                        
                        
                        
                    }
                    HStack {
                        ColorPicker("Text", selection: context.foregroundColorBinding)
                        ColorPicker("Background", selection: context.backgroundColorBinding)
                        
                        
                    }
                }
                .padding()
                .background(.thinMaterial)
                
            }
            
        }
        .cornerRadius(16)
        .photosPicker(isPresented: $isPhotoPickerPresented,
                      selection: $photoSelection,
                      matching: .all(of: [.images, .not(.livePhotos)]))
        .onChange(of: photoSelection) { newValue in
            Task {
                if let selectedPhotoData = try? await newValue?.loadTransferable(type: Data.self),
                   let image = ImageRepresentable(data: selectedPhotoData) {
                    let lowerBound = context.selectedRange.lowerBound
                    context.pasteImage(image, at: lowerBound)
                }
            }
        }
        
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
