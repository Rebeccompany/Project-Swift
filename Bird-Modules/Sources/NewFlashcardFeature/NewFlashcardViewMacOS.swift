//
//  NewFlashcardViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 28/10/22.
//

import SwiftUI
import HummingBird
import Models
import Storage
import Habitat
import RichTextKit
import Combine
#if os(macOS)
public struct NewFlashcardViewMacOS: View {
    @StateObject private var viewModel = NewFlashcardViewModelMacOS()
    
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    @State private var frontSize: CGFloat = 16
    @State private var backSize: CGFloat = 16
    @State private var selectedContext: Context = .front
    
    @StateObject private var frontContext = RichTextContext()
    @StateObject private var backContext = RichTextContext()
    
    @Environment (\.dismiss) private var dismiss
    
    var data: NewFlashcardWindowData
    
    var activeContext: RichTextContext? {
        if frontContext.isEditingText {
            return frontContext
        } else if backContext.isEditingText {
            return backContext
        } else { return nil }
    }
    
    public init(data: NewFlashcardWindowData) {
        self.data = data
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    sidebar
                        .frame(width: 250, height: proxy.size.height)
                    Group {
                        switch selectedContext {
                        case .front:
                            content(context: frontContext, selectedContext: .front, text: $viewModel.flashcardFront,textSize: $frontSize)
                        case .back:
                            content(context: backContext, selectedContext: .back, text: $viewModel.flashcardBack, textSize: $backSize)
                        }
                    }
                        .frame(width: proxy.size.width - 250, height: proxy.size.height)
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .navigationTitle(NSLocalizedString("novo_flashcard", bundle: .module, comment: ""))
            .onChange(of: frontSize) { newValue in
                frontContext.fontSize = newValue
            }
            .onChange(of: backSize) { newValue in
                backContext.fontSize = newValue
            }
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        ScrollView {
            Form {
                Section {
                    Picker("", selection: $selectedContext) {
                        Text("front").tag(Context.front)
                        Text("back").tag(Context.back)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Content")
                        .font(.headline)
                }
                
                Section {
                    IconColorGridView {
                        colorGridItems
                    }
                } header: {
                    Text("Colors")
                        .font(.headline)
                        .padding(.top)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder private func content(context: RichTextContext, selectedContext: Context, text: Binding<NSAttributedString>, textSize: Binding<CGFloat>) -> some View {
        FlashcardTextEditorViewMacOS(
            text: text, color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
            side: NSLocalizedString(selectedContext == .front ? "frente" : "back", bundle: .module, comment: ""),
            context: context,
            isFront: selectedContext == .front
        )
        .padding()
        .toolbar {
            ToolbarItem {
                italicButton(selectedContext: context)
            }
            
            ToolbarItem {
                boldButton(selectedContext: context)
            }
            
            ToolbarItem {
                underlineButton(selectedContext: context)
            }
            
            ToolbarItem {
                alignmentMenu(selectedContext: context)
            }
            
            ToolbarItem {
                textColorButton(selectedContext: context)
            }
            
            ToolbarItem {
                textBackgroundColor(selectedContext: context)
            }
            
            ToolbarItem {
                HStack {
                    Spacer()
                    sizeTools(size: textSize, selectedContext: context)
                        .frame(width: 115)
                        .padding(.horizontal, 4)
                        .background(.regularMaterial)
                        .cornerRadius(8)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func italicButton(selectedContext: RichTextContext) -> some View {
        Button { selectedContext.isItalic.toggle() } label: {
            Image.richTextStyleItalic
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
        .tint(selectedContext.isItalic ? HBColor.actionColor : nil)
        .keyboardShortcut("i", modifiers: .command)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(selectedContext.isItalic ? 0.05 : 0))
        )
    }
    
    @ViewBuilder
    private func boldButton(selectedContext: RichTextContext) -> some View {
        Button { selectedContext.isBold.toggle() } label: {
            Image.richTextStyleBold
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
        .tint(selectedContext.isBold ? HBColor.actionColor : nil)
        .keyboardShortcut("b", modifiers: .command)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(selectedContext.isBold ? 0.05 : 0))
        )
    }
    
    @ViewBuilder
    private func underlineButton(selectedContext: RichTextContext) -> some View {
        Button { selectedContext.isUnderlined.toggle() } label: {
            Image.richTextStyleUnderline
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
        .tint(selectedContext.isUnderlined ? HBColor.actionColor : nil)
        .keyboardShortcut("u", modifiers: .command)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(selectedContext.isUnderlined ? 0.05 : 0))
        )
    }
    
    @ViewBuilder
    private func textColorButton(selectedContext: RichTextContext) -> some View {
        ZStack {
            Image(systemName: "character")
                .zIndex(2)
                .foregroundColor(selectedContext.foregroundColor?.isLight ?? false ? .black : .white)
                .font(.system(size: 14, weight: .bold))
            ColorPicker("", selection: selectedContext.foregroundColorBinding, supportsOpacity: false)
        }
    }
    
    @ViewBuilder
    private func textBackgroundColor(selectedContext: RichTextContext) -> some View {
        ZStack {
            Image(systemName: "highlighter")
                .zIndex(2)
                .foregroundColor(checkBackgroundColor(color: selectedContext.foregroundColor ?? .clear))
                .font(.system(size: 14, weight: .bold))
            ColorPicker("", selection: selectedContext.backgroundColorBinding, supportsOpacity: true)
        }
    }
    
    private func checkBackgroundColor(color: ColorRepresentable) -> Color {
        if color == .clear {
            return Color.gray
        } else if color.isLight {
            return .black
        } else {
            return .white
        }
    }
    
    @ViewBuilder
    private var colorGridItems: some View {
        ForEach(viewModel.colors, id: \.self) { color in
            Button {
                viewModel.currentSelectedColor = color
            } label: {
                HBColor.color(for: color)
                    .frame(width: 45, height: 45)
            }
            .accessibility(label: Text(CollectionColor.getColorString(color)))
            .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedColor == color ? true : false))
        }
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        Button {
            activeAlert = .confirm
            showingAlert = true
        } label: {
            Text("apagar_flashcard", bundle: .module)
        }
        .buttonStyle(DeleteButtonStyle())
        
    }
    
    @ViewBuilder
    private var saveButton: some View {
        Button {
            if viewModel.editingFlashcard == nil {
                do {
                    try viewModel.createFlashcard()
                    viewModel.reset()
                } catch {
                    activeAlert = .error
                    showingAlert = true
                    selectedErrorMessage = .createCard
                }
            } else {
                do {
                    try viewModel.editFlashcard()
                } catch {
                    activeAlert = .error
                    showingAlert = true
                    selectedErrorMessage = .editCard
                }
            }
            
            activeAlert = .close
            showingAlert = true
            
        } label: {
            HStack {
                Spacer()
                Text(NSLocalizedString("salvar", bundle: .module, comment: ""))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(HBColor.collectionTextColor)
                Spacer()
            }
            .frame(height: 46)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(HBColor.actionColor)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func customAlert() -> Alert {
        switch activeAlert {
        case .error:
            return Alert(title: Text(selectedErrorMessage.texts.title),
                         message: Text(selectedErrorMessage.texts.message),
                         dismissButton: .default(Text("fechar", bundle: .module)))
        case .confirm:
            return Alert(title: Text("alert_delete_flashcard", bundle: .module),
                         message: Text("alert_delete_flashcard_text", bundle: .module),
                         primaryButton: .destructive(Text("deletar", bundle: .module)) {
                do {
                    try viewModel.deleteFlashcard()
                    dismiss()
                } catch {
                    activeAlert = .error
                    showingAlert = true
                    selectedErrorMessage = .deleteCard
                }
                         },
                         secondaryButton: .cancel(Text("cancelar", bundle: .module))
            )
        case .close:
            return Alert(title: Text(NSLocalizedString("cartao_salvo", bundle: .module, comment: "")), message: Text(NSLocalizedString("fechar_janela", bundle: .module, comment: "")))
        }
    }

    @ViewBuilder
    private func alignmentMenu(selectedContext: RichTextContext) -> some View {
        Menu {
            ForEach(RichTextAlignment.allCases) { alignment in
                Button {
                    selectedContext.alignment = alignment
                } label: {
                    Label {
                        Text(alignment.rawValue)
                    } icon: {
                        alignment.icon
                    }
                }
            }
            
        } label: {
            selectedContext.alignment.icon
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
    }
    
    func sizeTools(size: Binding<CGFloat>, selectedContext: RichTextContext) -> some View {
        HStack {
            Button {
                selectedContext.decrementFontSize()
                size.wrappedValue -= CGFloat(1)
            } label: {
                Image(systemName: "minus")
                    .frame(width: 10, height: 10)
            }
            .keyboardShortcut("-", modifiers: .command)
            
            FontSizePicker(selection: size)
                .labelsHidden()
                .frame(minWidth: 50)
            
            Button {
                selectedContext.incrementFontSize()
                size.wrappedValue += CGFloat(1)
            } label: {
                Image(systemName: "plus")
                    .frame(width: 10, height: 10)
            }
            .keyboardShortcut("+", modifiers: .command)
        }
    }
    
}

extension View {
    
    fileprivate func highlighted(if condition: Bool) -> some View {
        foregroundColor(condition ? .accentColor : .primary)
    }
}

struct NewFlashcardViewMacOS_Previews: PreviewProvider {
    static var previews: some View {
            HabitatPreview {
                NewFlashcardViewMacOS(data: NewFlashcardWindowData(deckId: .init()))
            }
            .frame(minWidth: 780, minHeight: 640)
    }
}

extension NSColor {
    var isLight: Bool {
        guard let components = cgColor.components, components.count > 2 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return (brightness > 0.5)
    }
}

enum Context {
    case front, back
}
#endif
