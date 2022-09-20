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
    @State private var showingErrorAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
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
                    FlashcardTextEditorView(color: .red, side: "Frente", cardText: $viewModel.flashcardFront)
                        .focused($focus, equals: NewFlashcardFocus.front)
                        .frame(minHeight: 200)
                    
                    FlashcardTextEditorView(color: .red, side: "Verso", cardText: $viewModel.flashcardBack)
                        .focused($focus, equals: NewFlashcardFocus.back)
                        .frame(minHeight: 200)
                    
                    Text("Ícones")
                        .font(.callout)
                        .bold()
                        .padding(.top)
                    
                    IconColorGridView {
                        ForEach(viewModel.colors, id: \.self) { color in
                            Button {
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
                    
                    if viewModel.editingFlashcard == nil {
                        Button {
                            do {
                                try viewModel.deleteFlashcard()
                            } catch {
                                selectedErrorMessage = .deleteCard
                                showingErrorAlert = true
                            }
                        } label: {
                            Text("Apagar Baralho")
                        }
                        .buttonStyle(DeleteButtonStyle())
                    }
        
                }
                .onAppear(perform: viewModel.startUp)
                .padding()
                
                .navigationTitle(viewModel.editingFlashcard != nil ? "Editar baralho" : "Criar Baralho")
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("OK") {
                            if viewModel.editingFlashcard == nil {
                                viewModel.createFlashcard()
                            } else {
                                do {
                                    try viewModel.editFlashcard()
                                } catch {
                                    selectedErrorMessage = .editCard
                                    showingErrorAlert = true
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
                
                .alert(isPresented: $showingErrorAlert) {
                    Alert(title: Text(selectedErrorMessage.texts.title),
                          message: Text(selectedErrorMessage.texts.message),
                          dismissButton: .default(Text("Fechar")))
            }
                
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
            .viewBackgroundColor(HBColor.primaryBackground)
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
            }
            
        }
    }
}


struct NewFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NewFlashcardView(viewModel: NewFlashcardViewModel(colors: CollectionColor.allCases, deckRepository: DeckRepositoryMock(), deck: Deck(id: UUID(), name: "asdsa", icon: "book", color: .red, collectionId: nil, cardsIds: [])))
    }
}
