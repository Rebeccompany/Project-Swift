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

public struct NewFlashcardView: View {
    @ObservedObject private var viewModel: NewFlashcardViewModel
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    @FocusState private var focus: NewFlashcardFocus?
    private var okButtonState: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    public init(viewModel: NewFlashcardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    FlashcardTextEditorView(
                        color: viewModel.currentSelectedColor != nil ?
                        HBColor.getHBColrFromCollectionColor(viewModel.currentSelectedColor ?? CollectionColor.darkBlue)
                        : HBColor.collectionPink,
                        side: "Frente",
                        cardText: $viewModel.flashcardFront
                    )
                    .focused($focus, equals: NewFlashcardFocus.front)
                    .frame(minHeight: 200)
                    
                    FlashcardTextEditorView(
                        color: viewModel.currentSelectedColor != nil ?
                        HBColor.getHBColrFromCollectionColor(viewModel.currentSelectedColor ?? CollectionColor.darkBlue)
                        : HBColor.collectionPink,
                        side: "Verso",
                        cardText: $viewModel.flashcardBack
                    )
                    .focused($focus, equals: NewFlashcardFocus.back)
                    .frame(minHeight: 200)
                    
                    Text("Cores")
                        .font(.callout)
                        .bold()
                        .padding(.top)
                    
                    IconColorGridView {
                        ForEach(viewModel.colors, id: \.self) { color in
                            Button {
                                viewModel.breakproint()
                                viewModel.currentSelectedColor = color
                            } label: {
                                HBColor.getHBColrFromCollectionColor(color)
                                    .frame(width: 45, height: 45)
                            }
                            .accessibility(label: Text(CollectionColor.getColorString(color)))
                            .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedColor == color ? true : false))
                        }
                    }
                    
                    Spacer()
                    
                    if viewModel.editingFlashcard != nil {
                        Button {
                            activeAlert = .confirm
                            showingAlert = true
                        } label: {
                            Text("Apagar Flashcard")
                        }
                        .buttonStyle(DeleteButtonStyle())
                    }
        
                }
                .padding()
                
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
            .viewBackgroundColor(HBColor.primaryBackground)
            .navigationTitle(viewModel.editingFlashcard != nil ? "Editar Flashcard" : "Criar Flashcard")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showingAlert) {
                switch activeAlert {
                case .error:
                    return Alert(title: Text(selectedErrorMessage.texts.title),
                                 message: Text(selectedErrorMessage.texts.message),
                                 dismissButton: .default(Text("Fechar")))
                case .confirm:
                    return Alert(title: Text("Deseja apagar este flashcard?"),
                                 message: Text("Você perderá permanentemente o conteúdo deste flashcard."),
                                 primaryButton: .destructive(Text("Apagar")) {
                                    do {
                                        try viewModel.deleteFlashcard()
                                        dismiss()
                                    } catch {
                                        activeAlert = .error
                                        showingAlert = true
                                        selectedErrorMessage = .deleteCard
                                    }
                                 },
                                 secondaryButton: .cancel(Text("Cancelar"))
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
                        .accessibilityLabel(focus == .front ? "Subir foco do teclado desabilitado" : "Subir foco do teclado")


                    Button {
                        if focus == .front {
                            focus = .back
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                    }.disabled(focus == .back)
                        .accessibilityLabel(focus == .back ? "Descer foco do teclado desabilitado" : "Descer foco do teclado")

                    Button("Feito") {
                        focus = nil
                    }
                    .accessibilityLabel(Text("Botão de feito"))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        if viewModel.editingFlashcard == nil {
                            do {
                                try viewModel.createFlashcard()
                                dismiss()
                            } catch {
                                selectedErrorMessage = .createCard
                                showingAlert = true
                            }
                            
                        } else {
                            do {
                                try viewModel.editFlashcard()
                                dismiss()
                            } catch {
                                selectedErrorMessage = .editCard
                                showingAlert = true
                            }
                        }
                    }
                    .disabled(!viewModel.canSubmit)
                    .accessibilityLabel(!viewModel.canSubmit ? "OK desabilitado" : "OK")
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            
        }
    }
}


struct NewFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NewFlashcardView(viewModel: NewFlashcardViewModel(colors: CollectionColor.allCases, deckRepository: DeckRepositoryMock(), deck: Deck(id: UUID(), name: "asdsa", icon: "book", color: .red, collectionId: nil, cardsIds: [])))
    }
}
