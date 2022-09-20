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
    private var viewModel: NewDeckViewModel
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteDeck
    @State private var activeAlert: ActiveAlert = .error
    @Environment(\.dismiss) private var dismiss
    
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
                
                Text("Ícones")
                    .font(.callout)
                    .bold()
                    .padding(.top)
                
                IconColorGridView {
                    ForEach(viewModel.icons, id: \.self) { icon in
                        Button {
                            viewModel.currentSelectedIcon = icon
                        } label: {
                            Image(systemName: IconNames.getIconString(icon))
                                .frame(width: 45, height: 45)
                        }
                        .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedIcon == icon ? true : false))
                        
                    }
                }
                Spacer()
                
                if viewModel.editingDeck != nil {
                    Button {
                        activeAlert = .confirm
                        showingAlert = true
                    } label: {
                        Text("Apagar Deck")
                    }
                    .buttonStyle(DeleteButtonStyle())
                }
                
            }
            
            .onAppear(perform: viewModel.startUp)
            .padding()
            .alert(isPresented: $showingAlert) {
                switch activeAlert {
                case .error:
                    return Alert(title: Text(selectedErrorMessage.texts.title),
                                 message: Text(selectedErrorMessage.texts.message),
                                 dismissButton: .default(Text("Fechar")))
                case .confirm:
                    return Alert(title: Text("Deseja apagar este baralho?"),
                                 message: Text("Você perderá permanentemente o conteúdo deste baralho."),
                                 primaryButton: .destructive(Text("Apagar")) {
                                    do {
                                        try viewModel.deleteDeck()
                                        dismiss()
                                    } catch {
                                        activeAlert = .error
                                        showingAlert = true
                                        selectedErrorMessage = .deleteDeck
                                    }
                                 },
                                 secondaryButton: .cancel(Text("Cancelar"))
                    )
                    
                }
                
            }
            
            .viewBackgroundColor(HBColor.primaryBackground)
            
            
            .navigationTitle(viewModel.editingDeck != nil ? "Editar baralho" : "Criar Baralho")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        
                        if viewModel.editingDeck == nil {
                            do {
                                try viewModel.createDeck()
                                dismiss()
                            } catch {
                                activeAlert = .error
                                showingAlert = true
                                selectedErrorMessage = .createDeck
                            }
                        } else {
                            do {
                                try viewModel.editDeck()
                                dismiss()
                            } catch {
                                activeAlert = .error
                                showingAlert = true
                                selectedErrorMessage = .editDeck
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
        }
        .navigationViewStyle(.stack)
    }
}


struct NewDeckView_Previews: PreviewProvider {
    static var previews: some View {
        NewDeckView(viewModel: NewDeckViewModel(colors: CollectionColor.allCases, icons: IconNames.allCases, deckRepository: DeckRepositoryMock(), collectionId: UUID()))
            .preferredColorScheme(.dark)
    }
}
