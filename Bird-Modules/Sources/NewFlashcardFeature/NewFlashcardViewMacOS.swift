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
#warning("Texto inicia preto no flashcard e salva branco")
#warning("Cor inicia marcado preto mesmo nao sendo preto")
#warning("Tamanho da letra nao muda só de clicar no lado que está editando")
#warning("Clicar numa coleção estando dentro de um deck faz o app carregar infinitamente")
#warning("Estudar um deck pela primeira vez faz o app carregar infinitamente")
#if os(macOS)
public struct NewFlashcardViewMacOS: View {
    @StateObject private var viewModel = NewFlashcardViewModelMacOS()
    
    @State private var showingAlert: Bool = false
    @State private var showingCloseAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    
    @StateObject private var frontContext = RichTextContext()
    @StateObject private var backContext = RichTextContext()
    
    @State private var size: CGFloat = 14
    
    var data: NewFlashcardWindowData
    
    var activeContext: RichTextContext {
        if frontContext.hasSelectedRange {
            return frontContext
        } else {
            return backContext
        }
    }
    
    public init(data: NewFlashcardWindowData) {
        self.data = data
    }
    
    public var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            FlashcardTextEditorViewMacOS(
                                text: $viewModel.flashcardFront, color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                                side: NSLocalizedString("frente", bundle: .module, comment: ""),
                                context: frontContext
                            )
                            .id(NewFlashcardFocus.front)
                            .frame(minHeight: 450)
                            
                            FlashcardTextEditorViewMacOS(
                                text: $viewModel.flashcardBack, color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                                side: NSLocalizedString("verso", bundle: .module, comment: ""),
                                context: backContext
                            )
                            .id(NewFlashcardFocus.back)
                            .frame(minHeight: 450)
                        }
                        
                        Text("cores", bundle: .module)
                            .font(.callout)
                            .bold()
                            .padding(.top)
                        
                        IconColorGridView {
                            colorGridItems
                        }
                        
                        Spacer()
                        
                        if viewModel.editingFlashcard != nil {
                            HStack {
                                Spacer()
                                deleteButton
                                Spacer()
                                saveButton
                                Spacer()
                            }
                            .padding(.bottom, 30)
                            .padding(.top, 30)
                            
                        } else {
                            HStack {
                                Spacer()
                                saveButton
                                    .frame(width: 300)
                                    .padding(.bottom, 30)
                                    .padding(.top, 30)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    
                    
                }
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
                .viewBackgroundColor(HBColor.primaryBackground)
                .navigationTitle(viewModel.editingFlashcard == nil ? NSLocalizedString("criar_flashcard", bundle: .module, comment: "") : NSLocalizedString("editar_flashcard", bundle: .module, comment: ""))
                .onAppear {
                    viewModel.startUp(data)
                }
                .onReceive(viewModel.updateTextFieldContextPublisher) { _ in
                    frontContext.shouldUpdateTextField()
                    backContext.shouldUpdateTextField()
                }
                .alert(isPresented: $showingAlert) {
                    customAlert()
                }
                .alert(isPresented: $showingCloseAlert) {
                    return Alert(title: Text("Cartão Salvo!"), message: Text("Seu cartão foi salvo no baralho, essa janela pode ser fechada"))
                }
                .toolbar {
                    
                    ToolbarItem {
                        italicButton
                    }
                    
                    ToolbarItem {
                        boldButton
                    }
                    
                    ToolbarItem {
                        underlineButton
                    }
                    
                    ToolbarItem {
                        alignmentMenu
                    }
                    
                    ToolbarItem {
                        textColorButton
                    }
                    
                    ToolbarItem {
                        textBackgroundColor
                    }
                    
                    ToolbarItem {
                        HStack {
                            Spacer()
                            sizeTools(size: $size)
                                .frame(width: 115)
                                .padding(.horizontal, 4)
                                .background(.regularMaterial)
                                .cornerRadius(8)
                            Spacer()
                        }
                    }
                }
            }
        }
        .onChange(of: size) { newValue in
            activeContext.fontSize = newValue
        }
    }
    
    @ViewBuilder
    private var italicButton: some View {
        Button { activeContext.isItalic.toggle() } label: {
            Image.richTextStyleItalic
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
        .tint(activeContext.isItalic ? HBColor.actionColor : nil)
        .keyboardShortcut("i", modifiers: .command)
    }
    
    @ViewBuilder
    private var boldButton: some View {
        Button { activeContext.isBold.toggle() } label: {
            Image.richTextStyleBold
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
        .tint(activeContext.isBold ? HBColor.actionColor : nil)
        .keyboardShortcut("b", modifiers: .command)
    }
    
    @ViewBuilder
    private var underlineButton: some View {
        Button { activeContext.isUnderlined.toggle() } label: {
            Image.richTextStyleUnderline
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
        .tint(activeContext.isUnderlined ? HBColor.actionColor : nil)
        .keyboardShortcut("u", modifiers: .command)
    }
    
    @ViewBuilder
    private var textColorButton: some View {
        HBColorPicker {
            Image(systemName: "character")
                .font(.system(size: 18))
        } onColorSelected: { color in
            activeContext.foregroundColorBinding.wrappedValue = color
        }
        .buttonStyle(.bordered)
    }
    
    @ViewBuilder
    private var textBackgroundColor: some View {
        HBColorPicker {
            Image(systemName: "highlighter")
                .font(.system(size: 14))
        } onColorSelected: { color in
            activeContext.backgroundColorBinding.wrappedValue = color
        }
        .buttonStyle(.bordered)
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
            
            showingCloseAlert = true
            
        } label: {
            HStack {
                Spacer()
                Text("Salvar")
                    .font(.system(size: 14, weight: .bold))
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
                } catch {
                    activeAlert = .error
                    showingAlert = true
                    selectedErrorMessage = .deleteCard
                }
            },
                         secondaryButton: .cancel(Text("cancelar", bundle: .module))
            )
        }
    }

    @ViewBuilder
    private var alignmentMenu: some View {
        Menu {
            ForEach(RichTextAlignment.allCases) { alignment in
                Button {
                    activeContext.alignment = alignment
                } label: {
                    Label {
                        Text(alignment.rawValue)
                    } icon: {
                        alignment.icon
                    }
                }
            }
            
        } label: {
            activeContext.alignment.icon
                .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
    }
    
    func sizeTools(size: Binding<CGFloat>) -> some View {
        HStack {
            Button {
                activeContext.decrementFontSize()
                self.size -= CGFloat(1)
                self.size = activeContext.fontSize
            } label: {
                Image(systemName: "minus")
                    .frame(width: 10, height: 10)
            }
            .keyboardShortcut("-", modifiers: .command)
            
            FontSizePicker(selection: size)
                .labelsHidden()
                .frame(minWidth: 50)
            
            Button {
                activeContext.incrementFontSize()
                self.size += CGFloat(1)
                self.size = activeContext.fontSize
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
    }
}
#endif
