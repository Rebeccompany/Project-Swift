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

struct NewFlashcardView: View {
    @ObservedObject
    private var viewModel: NewFlashcardViewModel
    @Environment(\.dismiss) private var dismiss
    
    public init(viewModel: NewFlashcardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        NavigationView {
            
            VStack (alignment: .leading) {
                FlashcardTextEditorView(color: .red, side: "Frente", cardText: .constant(""))
                
                FlashcardTextEditorView(color: .red, side: "Verso", cardText: .constant(""))
                
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
            }
            .onAppear(perform: viewModel.startUp)
            .padding()
//            .alert("Ocorreu um erro interno, tente novamente", isPresented: $viewModel.showingErrorAlert) {
//                Button("OK", role: .cancel) {
//                    viewModel.showingErrorAlert = false
//                }
//            }
            
            .ViewBackgroundColor(HBColor.primaryBackground)
            
            
            .navigationTitle(viewModel.editingFlashcard != nil ? "Editar baralho" : "Criar Baralho")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        
                        if viewModel.editingFlashcard == nil {
                            viewModel.createFlashcard()
                        } else {
//                            viewModel.editDeck()
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
        }
    }
}

struct NewFlashcardView_Previews: PreviewProvider {
    static var previews: some View {
        NewFlashcardView(viewModel: NewFlashcardViewModel(colors: CollectionColor.allCases, deckRepository: DeckRepositoryMock(), deck: Deck(id: UUID(), name: "asdsa", icon: "book", color: .red, collectionsIds: [], cardsIds: [])))
    }
}
