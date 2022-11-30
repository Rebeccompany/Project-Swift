//
//  NewDeckViewiOS.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage
import Habitat

#if os(iOS)
public struct NewDeckViewiOS: View {
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
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Section {
                        TextField("", text: $viewModel.deckName)
                            .textFieldStyle(CollectionDeckTextFieldStyle())
                            .padding(.bottom)
                            .focused($selectedField, equals: 0)
                    } header: {
                        Text("nome", bundle: .module)
                            .font(.callout)
                            .bold()
                    }
                    
                    Section {
                        TextEditor(text: $viewModel.description)
                            .focused($selectedField, equals: 1)
                            .frame(height: 150)
                            .padding()
                            .background(HBColor.secondaryBackground)
                            .cornerRadius(12)
                        
                    } header: {
                        Text("description", bundle: .module)
                            .font(.callout)
                            .bold()
                    }
                    
                    Section {
                        Picker(selection: $viewModel.currentSelectedCategory) {
                            ForEach(DeckCategory.allCases, id: \.self) { category in
                                getCategoryLabel(category: category)
                            }
                        } label: {
                            Text("categoria_selecionada", bundle: .module)
                        }
                        .pickerStyle(.navigationLink
                        )
                        .padding()
                        .background(HBColor.secondaryBackground)
                        .cornerRadius(12)
                        
                    } header: {
                        Text("categoria", bundle: .module)
                            .font(.callout)
                            .bold()
                    }

                    Section {
                        IconColorGridView {
                            ForEach(viewModel.colors.filter { $0 != CollectionColor.white }, id: \.self) { color in
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
                    } header: {
                        Text("cores", bundle: .module)
                            .font(.callout)
                            .bold()
                    }

                    Section {
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
                    } header: {
                        Text("icones", bundle: .module)
                            .font(.callout)
                            .bold()
                            .padding(.top)
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
                .confirmationDialog("Are you sure you want to delete this deck?", isPresented: $showingAlert) {
                    Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                        do {
                            try viewModel.deleteDeck(editingDeck: editingDeck)
                            editMode = .inactive
                            dismiss()
                        } catch {
                            activeAlert = .error
                            showingAlert = true
                            selectedErrorMessage = .deleteDeck
                        }
                    }
                } message: {
                    switch activeAlert {
                    case .error:
                        Text(NSLocalizedString("alert_delete_deck_error_text", bundle: .module, comment: ""))
                    case .confirm:
                        Text(NSLocalizedString("alert_delete_deck", bundle: .module, comment: ""))
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
                
                ToolbarItem(placement: .confirmationAction) {
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
        .interactiveDismissDisabled(selectedField != nil ? true : false)
        
    }
}


struct NewDeckViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NewDeckViewiOS(collection: nil, editingDeck: nil, editMode: .constant(.active))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
