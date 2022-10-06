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
                    Text("nome", bundle: .module)
                        .font(.callout)
                        .bold()
                    
                    TextField("", text: $viewModel.deckName)
                        .textFieldStyle(CollectionDeckTextFieldStyle())
                        .padding(.bottom)
                        .focused($selectedField, equals: 0)
                        
                    
                    Text("cores", bundle: .module)
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
                    
                    Text("icones", bundle: .module)
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
                        } label: {
                            Text("apagar_deck", bundle: .module)
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
                                     dismissButton: .default(Text("fechar", bundle: .module)))
                    case .confirm:
                        return Alert(title: Text("alert_delete_deck", bundle: .module),
                                     message: Text("alert_delete_deck_text", bundle: .module),
                                     primaryButton: .destructive(Text("deletar", bundle: .module)) {
                                        do {
                                            try viewModel.deleteDeck(editingDeck: editingDeck)
                                            editMode = .inactive
                                            dismiss()
                                        } catch {
                                            activeAlert = .error
                                            showingAlert = true
                                            selectedErrorMessage = .deleteDeck
                                        }
                                     },
                                     secondaryButton: .cancel(Text("cancelar", bundle: .module))
                        )
                        
                    }
                    
                }
                .navigationTitle(editingDeck == nil ? NSLocalizedString("criar_deck", bundle: .module, comment: "") : NSLocalizedString("editar_deck", bundle: .module, comment: ""))
                .navigationBarTitleDisplayMode(.inline)
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
                        selectedField = nil
                    }
                    .accessibilityLabel(Text("botao_feito", bundle: .module))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
                        
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
                    Button(NSLocalizedString("cancelar", bundle: .module, comment: "")) {
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
