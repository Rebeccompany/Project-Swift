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
    @ObservedObject
    private var viewModel: NewFlashcardViewModel
    @State private var showingErrorAlert: Bool = true
    @State var selectedErrorMessage: AlertText = .delete
    
    @Environment(\.dismiss) private var dismiss
    
    public init(viewModel: NewFlashcardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                FlashcardTextEditorView(color: .red, side: "Frente", cardText: $viewModel.flashcardFront)
                
                FlashcardTextEditorView(color: .red, side: "Verso", cardText: $viewModel.flashcardBack)
                
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
                            selectedErrorMessage = .delete
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
            
            .ViewBackgroundColor(HBColor.primaryBackground)
            
            
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
                                selectedErrorMessage = .edit
                                showingErrorAlert = true
                            }
                        }
                    }
                    .disabled(!viewModel.canSubmit)
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
    }
}

enum AlertText {
    case delete
    case edit
    
    var texts: (title: String, message: String) {
        switch self {
        case .delete:
            return ("Erro ao apagar flashcard", "Algo deu errado! Por favor, tente novamente.")
        case .edit:
            return ("Erro ao editar flashcard", "Algo deu errado! Por favor, tente novamente.")
            
        }
    }
}


struct NewFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NewFlashcardView(viewModel: NewFlashcardViewModel(colors: CollectionColor.allCases, deckRepository: DeckRepositoryMock(), deck: Deck(id: UUID(), name: "asdsa", icon: "book", color: .red, collectionsIds: [], cardsIds: [])))
    }
}
