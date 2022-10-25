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

public struct NewFlashcardView: View {
    @StateObject private var viewModel: NewFlashcardViewModel = NewFlashcardViewModel()
    
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    
    @FocusState private var focus: NewFlashcardFocus?
    private var okButtonState: String = ""
    
    @Environment(\.dismiss) private var dismiss
    

    var deck: Deck
    var editingFlashcard: Card?
    
    public init(deck: Deck, editingFlashcard: Card? = nil) {
        self.deck = deck
        self.editingFlashcard = editingFlashcard
    }
    
    public var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    FlashcardTextEditorView(
                        color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                        side: NSLocalizedString("frente", bundle: .module, comment: ""),
                        cardText: $viewModel.flashcardFront
                    )
                    .focused($focus, equals: NewFlashcardFocus.front)
                    .frame(minHeight: 280)
                    
                    FlashcardTextEditorView(
                        color: HBColor.color(for: viewModel.currentSelectedColor ?? CollectionColor.darkBlue),
                        side: NSLocalizedString("verso", bundle: .module, comment: ""),
                        cardText: $viewModel.flashcardBack
                    )
                    .focused($focus, equals: NewFlashcardFocus.back)
                    .frame(minHeight: 280)
                    
                    Text("cores", bundle: .module)
                        .font(.callout)
                        .bold()
                        .padding(.top)
                    
                    IconColorGridView {
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
                    
                    Spacer()
                    
                    if editingFlashcard != nil {
                        Button {
                            activeAlert = .confirm
                            showingAlert = true
                        } label: {
                            Text("apagar_flashcard", bundle: .module)
                        }
                        .buttonStyle(DeleteButtonStyle())
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
            .alert(isPresented: $showingAlert) {
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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        if focus == .back {
                            focus = .front
                        }
                    } label: {
                        Image(systemName: "chevron.up")
                    }.disabled(focus == .front)
                        .accessibilityLabel(focus == .front ? NSLocalizedString("moveup_focus_disabled", bundle: .module, comment: "") : NSLocalizedString("moveup_focus", bundle: .module, comment: ""))


                    Button {
                        if focus == .front {
                            focus = .back
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                    }.disabled(focus == .back)
                        .accessibilityLabel(focus == .back ? NSLocalizedString("down_focus_disabled", bundle: .module, comment: "") : NSLocalizedString("down_focus", bundle: .module, comment: ""))

                    Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
                        focus = nil
                    }
                    .accessibilityLabel(Text("botao_feito", bundle: .module))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
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
                    .accessibilityLabel(!viewModel.canSubmit ? NSLocalizedString("feito_disabled", bundle: .module, comment: "") : NSLocalizedString("feito", bundle: .module, comment: ""))
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(NSLocalizedString("cancelar", bundle: .module, comment: "")) {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            
        }
        .interactiveDismissDisabled(focus != nil ? true : false)
    }
}


struct NewFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NewFlashcardView(deck: Deck(id: UUID(), name: "Nome", icon: "chove", color: .darkBlue, collectionId: nil, cardsIds: [], category: DeckCategory.arts), editingFlashcard: nil)
        }
    }
}
