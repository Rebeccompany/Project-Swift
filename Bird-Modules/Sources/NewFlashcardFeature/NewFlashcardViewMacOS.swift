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

public struct NewFlashcardViewMacOS: View {
    @StateObject private var viewModel: NewFlashcardViewModel = NewFlashcardViewModel()
    
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    
    @StateObject private var frontContext = RichTextContext()
    @StateObject private var backContext = RichTextContext()
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var deck: Deck?
    @State private var editingFlashcard: Card?
    
    var data: NewFlashcardWindowData
    
    public init(data: NewFlashcardWindowData) {
        self.data = data
    }
    
    public var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        layout {
                            FlashcardTextEditorView(
                                text: $viewModel.flashcardFront, color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                                side: NSLocalizedString("frente", bundle: .module, comment: ""),
                                context: frontContext
                            )
                            .id(NewFlashcardFocus.front)
                            #if os(iOS)
                            .frame(minHeight: horizontalSizeClass == . compact ? 400 : 600)
                            #endif
                            
                            FlashcardTextEditorView(
                                text: $viewModel.flashcardBack, color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                                side: NSLocalizedString("verso", bundle: .module, comment: ""),
                                context: backContext
                            )
                            .id(NewFlashcardFocus.back)
#if os(iOS)
                            .frame(minHeight: horizontalSizeClass == . compact ? 400 : 600)
                            #endif
                        }
                        
                        Text("cores", bundle: .module)
                            .font(.callout)
                            .bold()
                            .padding(.top)
                        
                        IconColorGridView {
                           colorGridItems
                        }
                        
                        Spacer()
                        
                        if editingFlashcard != nil {
                            deleteButton
                        }
                    }
                    .padding()
                    
                }
                .scrollContentBackground(.hidden)
                .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
                .viewBackgroundColor(HBColor.primaryBackground)
                .navigationTitle(editingFlashcard == nil ? NSLocalizedString("criar_flashcard", bundle: .module, comment: "") : NSLocalizedString("editar_flashcard", bundle: .module, comment: ""))
#if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .onAppear {
                    viewModel.startUp(editingFlashcard: editingFlashcard)
                }
                .alert(isPresented: $showingAlert) {
                    customAlert()
                }
                .toolbar {
//                    ToolbarItemGroup(placement: .keyboard) {
//                        customrightToolbarItemGroup
//                    }
#if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        customNavigationToolbar
                    }
                    #endif
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button(NSLocalizedString("cancelar", bundle: .module, comment: "")) {
                            dismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
                
                .onChange(of: frontContext.isEditingText) { newValue in
#if os(iOS)
                    if newValue, horizontalSizeClass == .compact {
                        withAnimation {
                            proxy.scrollTo(NewFlashcardFocus.front, anchor: .center)
                        }
                    }
                    #endif
                }
                .onChange(of: backContext.isEditingText) { newValue in
#if os(iOS)
                    if newValue, horizontalSizeClass == .compact {
                        withAnimation {
                            proxy.scrollTo(NewFlashcardFocus.back, anchor: UnitPoint(x: 0.5, y: 0.8))
                        }
                    }
                    #endif
                }
            }
        }
        .onReceive(viewModel.fetchInitialDeck(data.deckId)) { deck in
            self.deck = deck
        }
        .onReceive(viewModel.fetchEditingCard(data.editingFlashcardId)) { card in
            self.editingFlashcard = card
            guard let card else { return }
            viewModel.setupDeckContentIntoFields(card)
        }
    }
    
    @ViewBuilder
    private func layout<Content: View>(@ViewBuilder content: () -> Content) -> some View {
#if os(iOS)
        if horizontalSizeClass == .compact {
            VStack(alignment: .leading) {
                content()
            }
        } else {
            HStack {
                content()
            }
        }
        #elseif os(macOS)
        HStack {
            content()
        }
        #endif
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
                        try viewModel.deleteFlashcard(editingFlashcard: editingFlashcard)
                        dismiss()
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
    
//    @ViewBuilder
//    private var customrightToolbarItemGroup: some View {
//        Spacer()
//        Button {
//            if focus == .back {
//                focus = .front
//            }
//        } label: {
//            Image(systemName: "chevron.up")
//        }
//        .disabled(focus == .front)
//        .accessibilityLabel(focus == .front ? NSLocalizedString("moveup_focus_disabled", bundle: .module, comment: "") : NSLocalizedString("moveup_focus", bundle: .module, comment: ""))
//
//
//        Button {
//            if focus == .front {
//                focus = .back
//            }
//        } label: {
//            Image(systemName: "chevron.down")
//        }
//        .disabled(focus == .back)
//        .accessibilityLabel(focus == .back ? NSLocalizedString("down_focus_disabled", bundle: .module, comment: "") : NSLocalizedString("down_focus", bundle: .module, comment: ""))
//
//        Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
//            focus = nil
//        }
//        .accessibilityLabel(Text("botao_feito", bundle: .module))
//    }
    
    @ViewBuilder
    private var customNavigationToolbar: some View {
            Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
                guard let deck else { return }
                
                if editingFlashcard == nil {
                    do {
                        try viewModel.createFlashcard(for: deck)
                        dismiss()
                    } catch {
                        selectedErrorMessage = .createCard
                        showingAlert = true
                    }
                    
                } else {
                    do {
                        try viewModel.editFlashcard(editingFlashcard: editingFlashcard)
                        dismiss()
                    } catch {
                        selectedErrorMessage = .editCard
                        showingAlert = true
                    }
                }
            }
            .disabled(!viewModel.canSubmit)
            .accessibilityLabel(!viewModel.canSubmit ? NSLocalizedString("feito_disabled",
                                                                         bundle: .module,
                                                                         comment: "") : NSLocalizedString("feito",
                                                                                                          bundle: .module,
                                                                                                          comment: ""))
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

