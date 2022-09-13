//
//  NewDeckView.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage

public struct NewDeckView: View {
    @ObservedObject
    var viewModel: NewDeckViewModel
    @Environment(\.dismiss) var dismiss
    
    public init(viewModel: NewDeckViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("Nome")
                    .font(.callout)
                    .bold()
                
                TextField("", text: $viewModel.deckName)
                    .textFieldStyle(CollectionDeckTextFieldStyle())
                    .padding(.bottom)
                
                
                Text("Cores")
                    .font(.callout)
                    .bold()
                
                IconColorGridView {
                    ForEach (viewModel.colors, id: \.self) { color in
                        Button{
                            viewModel.currentSelectedColor = color
                        } label: {
                            HBColor.getHBColrFromCollectionColor(color)
                                .frame(width: 45, height: 45)
                        }
                        .accessibility(label: Text(CollectionColor.getColorString(color)))
                        .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedColor == color ? true : false))
                    }
                }
                
                Text("Ícones")
                    .font(.callout)
                    .bold()
                    .padding(.top)
                
                IconColorGridView {
                    ForEach (viewModel.icons, id: \.self) { icon in
                        Button{
                            viewModel.currentSelectedIcon = icon
                        } label: {
                            Image(systemName: IconNames.getIconString(icon))
                                .frame(width: 45, height: 45)
                        }
                        .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedIcon == icon ? true : false))
                        
                    }
                }
                Spacer()
                
                if (viewModel.editingDeck != nil) {
                    Button {
                        viewModel.deleteDeck()
                    } label: {
                        Text("Apagar Deck")
                    }
                    .buttonStyle(DeleteButtonStyle())
                }
                
            }
            
            .onAppear(perform: viewModel.startUp)
            .padding()
            .alert("Ocorreu um erro interno, tente novamente", isPresented: $viewModel.showingErrorAlert) {
                Button("OK", role: .cancel) {
                    viewModel.showingErrorAlert = false
                }
            }
            
            .ViewBackgroundColor(HBColor.primaryBackground)
            
            
            .navigationTitle(viewModel.editingDeck != nil ? "Editar baralho" : "Criar Baralho")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        
                        if viewModel.editingDeck == nil {
                            viewModel.createDeck()
                        } else {
                            viewModel.editDeck()
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
        .navigationViewStyle(.stack)
    }
}

struct NewDeckView_Previews: PreviewProvider {
    static var previews: some View {
        NewDeckView(viewModel: NewDeckViewModel(colors: CollectionColor.allCases, icons: IconNames.allCases, deckRepository: DeckRepositoryMock(), collectionId: [UUID()]))
            .preferredColorScheme(.dark)
    }
}
