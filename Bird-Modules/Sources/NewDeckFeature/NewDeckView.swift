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
import Habitat

public struct NewDeckView: View {
    @StateObject private var viewModel: NewDeckViewModel = NewDeckViewModel()
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteDeck
    @State private var activeAlert: ActiveAlert = .error
    @Environment(\.dismiss) private var dismiss
    @FocusState private var selectedField: Int?
    @Binding private var editMode: EditMode
    
    var editingDeck: Deck?
    var collection: DeckCollection?
    
    public init(collection: DeckCollection?, editingDeck: Deck?, editMode: Binding<EditMode>) {
        self.collection = collection
        self.editingDeck = editingDeck
        self._editMode = editMode
    }
    
    public var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Nome")
                        .font(.callout)
                        .bold()
                    
                    TextField("", text: $viewModel.deckName)
                        .textFieldStyle(CollectionDeckTextFieldStyle())
                        .padding(.bottom)
                        .focused($selectedField, equals: 0)
                        
                    
                    Text("Cores")
                        .font(.callout)
                        .bold()
                    
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
                    
                    Text("Ícones")
                        .font(.callout)
                        .bold()
                        .padding(.top)
                    
                    IconColorGridView {
                        ForEach(viewModel.icons, id: \.self) { icon in
                            Button {
                                viewModel.currentSelectedIcon = icon
                            } label: {
                                Image(systemName: icon.rawValue)
                                    .frame(width: 45, height: 45)
                            }
                            .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedIcon == icon ? true : false))
                            
                        }
                    }
                    Spacer()
                    
                    if editingDeck != nil {
                        Button {
                            activeAlert = .confirm
                            showingAlert = true
                            editMode = .inactive
                        } label: {
                            Text("Apagar Deck")
                        }
                        .buttonStyle(DeleteButtonStyle())
                    }
                    
                }
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
                                            try viewModel.deleteDeck(editingDeck: editingDeck)
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
                .navigationTitle(editingDeck != nil ? "Editar baralho" : "Criar Baralho")
                .navigationBarTitleDisplayMode(.inline)
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Feito") {
                        selectedField = nil
                    }
                    .accessibilityLabel(Text("Botão de feito"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        
                        if editingDeck == nil {
                            do {
                                try viewModel.createDeck(collection: collection)
                                dismiss()
                            } catch {
                                activeAlert = .error
                                showingAlert = true
                                selectedErrorMessage = .createDeck
                            }
                        } else {
                            do {
                                try viewModel.editDeck(editingDeck: editingDeck)
                                editMode = .inactive
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
                        editMode = .inactive
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .onAppear {
                viewModel.startUp(editingDeck: editingDeck)
            }
            
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
            .viewBackgroundColor(HBColor.primaryBackground)
        }
        
    }
}


struct NewDeckView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NewDeckView(collection: nil, editingDeck: nil, editMode: .constant(.active))
                .preferredColorScheme(.dark)
        }
    }
}
