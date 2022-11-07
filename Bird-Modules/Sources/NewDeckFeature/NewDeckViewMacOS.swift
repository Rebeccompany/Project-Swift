//
//   NewDeckViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 27/10/22.
//

import SwiftUI
import HummingBird
import Models
import Storage
import Habitat

#if os(macOS)
public struct NewDeckViewMacOS: View {
    @StateObject private var viewModel: NewDeckViewModel = NewDeckViewModel()
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteDeck
    @State private var activeAlert: ActiveAlert = .error
    
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var selectedField: Int?
    
    var editingDeck: Deck?
    var collection: DeckCollection?
    
    public init(collection: DeckCollection?, editingDeck: Deck?) {
        self.collection = collection
        self.editingDeck = editingDeck
    }
    
    public var body: some View {
        
        NavigationStack {
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
                                            #if os(iOS)
                                            editMode = .inactive
                                            #endif
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
                
            }
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        
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
                                dismiss()
                            } catch {
                                activeAlert = .error
                                showingAlert = true
                                selectedErrorMessage = .editDeck
                            }
                        }
                    } label: {
                        Text(NSLocalizedString("feito", bundle: .module, comment: ""))
                    }
                    .disabled(!viewModel.canSubmit)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(NSLocalizedString("cancelar", bundle: .module, comment: ""))
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                viewModel.startUp(editingDeck: editingDeck)
            }
            
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
            .viewBackgroundColor(HBColor.primaryBackground)
        }
        .interactiveDismissDisabled(selectedField != nil ? true : false)
        
    }
}


struct NewDeckViewMacOS_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NewDeckViewMacOS(collection: nil, editingDeck: nil)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
