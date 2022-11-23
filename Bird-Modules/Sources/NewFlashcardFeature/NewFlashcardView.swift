//
//  NewFlashcardView.swift
//  
//
//  Created by Rebecca Mello on 15/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage
import Habitat
import RichTextKit
import Combine

public struct NewFlashcardView: View {
    @StateObject private var viewModel: NewFlashcardViewModel = NewFlashcardViewModel()
    
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    
    @StateObject private var frontContext = RichTextContext()
    @StateObject private var backContext = RichTextContext()
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
//    @FocusState private var focus: NewFlashcardFocus?
    
    @Environment(\.dismiss) private var dismiss
    
    
    var deck: Deck
    var editingFlashcard: Card?
    
    public init(deck: Deck, editingFlashcard: Card? = nil) {
        self.deck = deck
        self.editingFlashcard = editingFlashcard
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
                                context: frontContext, isFront: true
                            )
                            .id(NewFlashcardFocus.front)
                            .frame(minHeight: horizontalSizeClass == . compact ? 400 : 600)
                            
                            FlashcardTextEditorView(
                                text: $viewModel.flashcardBack, color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                                side: NSLocalizedString("verso", bundle: .module, comment: ""),
                                context: backContext, isFront: false
                            )
                            .id(NewFlashcardFocus.back)
                            .frame(minHeight: horizontalSizeClass == . compact ? 400 : 600)
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
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    viewModel.startUp(editingFlashcard: editingFlashcard)
                }
                .confirmationDialog("Are you sure you want to delete this flashcard?", isPresented: $showingAlert) {
                    Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                        do {
                            try viewModel.deleteFlashcard(editingFlashcard: editingFlashcard)
                            dismiss()
                        } catch {
                            activeAlert = .error
                            showingAlert = true
                            selectedErrorMessage = .deleteCard
                        }
                    }
                } message: {
                    switch activeAlert {
                    case .error:
                        Text(NSLocalizedString("alert_delete_flashcard_error_text", bundle: .module, comment: ""))
                    case .confirm:
                        Text(NSLocalizedString("alert_delete_flashcard", bundle: .module, comment: ""))
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        customNavigationToolbar
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button(NSLocalizedString("cancelar", bundle: .module, comment: "")) {
                            dismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
                
                .onChange(of: frontContext.isEditingText) { newValue in
                    if newValue, horizontalSizeClass == .compact {
                        withAnimation {
                            proxy.scrollTo(NewFlashcardFocus.front, anchor: .center)
                        }
                    }
                }
                .onChange(of: backContext.isEditingText) { newValue in
                    if newValue, horizontalSizeClass == .compact {
                        withAnimation {
                            proxy.scrollTo(NewFlashcardFocus.back, anchor: UnitPoint(x: 0.5, y: 0.8))
                        }
                    }
                }     
            }
        }
    }
    
    @ViewBuilder
    private func layout<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if horizontalSizeClass == .compact {
            VStack(alignment: .leading) {
                content()
            }
        } else {
            HStack {
                content()
            }
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
    private var customNavigationToolbar: some View {
            Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
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


struct NewFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NewFlashcardView(deck: Deck(id: UUID(), name: "Nome", icon: "chove", color: .darkBlue, collectionId: nil, cardsIds: [], category: DeckCategory.arts, storeId: nil), editingFlashcard: nil)
        }
    }
}
