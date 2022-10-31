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
                        HStack {
                            FlashcardTextEditorView(
                                text: $viewModel.flashcardFront, color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                                side: NSLocalizedString("frente", bundle: .module, comment: ""),
                                context: frontContext
                            )
                            .id(NewFlashcardFocus.front)
                            .frame(minHeight: 450)
                            
                            FlashcardTextEditorView(
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
                .onAppear {
                    viewModel.startUp(editingFlashcard: editingFlashcard)
                }
                .alert(isPresented: $showingAlert) {
                    customAlert()
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button(NSLocalizedString("cancelar", bundle: .module, comment: "")) {
                            dismiss()
                        }
                        .foregroundColor(.red)
                    }
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

