//
//  NewCollectionViewiOS.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage
import Habitat

#if os(iOS)
public struct NewCollectionViewiOS: View {
    
    @StateObject private var viewModel: NewCollectionViewModel = NewCollectionViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State private var selectedErrorMessage: AlertText = .deleteCollection
    @FocusState private var selectedField: Int?
    var editingCollection: DeckCollection?
    @Binding private var editMode: EditMode

    public init(editingCollection: DeckCollection?, editMode: Binding<EditMode>) {
        self.editingCollection = editingCollection
        self._editMode = editMode
    }
    
    public var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("nome", bundle: .module)
                        .font(.callout)
                        .bold()
                    TextField("", text: $viewModel.collectionName)
                        .textFieldStyle(CollectionDeckTextFieldStyle())
                        .focused($selectedField, equals: 0)
                    Text("icones", bundle: .module)
                        .font(.callout)
                        .bold()
                        .padding(.top)
                    
                    IconColorGridView {
                        ForEach(viewModel.icons, id: \.self) {icon in
                            Button {
                                viewModel.currentSelectedIcon = icon
                                
                            } label: {
                                Image(systemName: icon.rawValue)
                                    .frame(width: 45, height: 45)
                            }
                            
                            .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedIcon == icon ? true : false))
                            .frame(width: 45, height: 45)
                        }
                    }
                    
                    Spacer()
                    
                    if editingCollection != nil {
                        Button {
                            activeAlert = .confirm
                            showingAlert = true
                        } label: {
                            Text("apagar_colecao", bundle: .module)
                        }
                        .buttonStyle(DeleteButtonStyle())
                        
                    }
                    
                }
                .onAppear { viewModel.startUp(editingCollection: editingCollection) }
                .padding()
                .alert(isPresented: $showingAlert) {
                    switch activeAlert {
                    case .error:
                        return Alert(title: Text(selectedErrorMessage.texts.title),
                                     message: Text(selectedErrorMessage.texts.message),
                                     dismissButton: .default(Text("fechar", bundle: .module)))
                    case .confirm:
                        return Alert(title: Text("alert_delete_collection", bundle: .module),
                                     message: Text("alert_delete_collection_text", bundle: .module),
                                     primaryButton: .destructive(Text("deletar", bundle: .module)) {
                                        do {
                                            try viewModel.deleteCollection(editingCollection: editingCollection)
                                            editMode = .inactive
                                            dismiss()
                                        } catch {
                                            activeAlert = .error
                                            showingAlert = true
                                            selectedErrorMessage = .deleteCollection
                                        }
                                     },
                                     secondaryButton: .cancel(Text("cancelar", bundle: .module))
                        )
                    }
                }
                .navigationTitle(editingCollection == nil ? NSLocalizedString("criar_colecao", bundle: .module, comment: "") : NSLocalizedString("editar_colecao", bundle: .module, comment: ""))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
                            selectedField = nil
                        }
                        .accessibilityLabel(Text("botao_feito", bundle: .module))
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button(NSLocalizedString("cancelar", bundle: .module, comment: "")) {
                            editMode = .inactive
                            dismiss()
                        }
                        .foregroundColor(Color.red)
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(NSLocalizedString("feito", bundle: .module, comment: "")) {
                            
                            if editingCollection == nil {
                                do {
                                    try viewModel.createCollection()
                                    dismiss()
                                } catch {
                                    activeAlert = .error
                                    showingAlert = true
                                    selectedErrorMessage = .createCollection
                                }
                            } else {
                                do {
                                    try viewModel.editCollection(editingCollection: editingCollection)
                                    editMode = .inactive
                                    dismiss()
                                } catch {
                                    activeAlert = .error
                                    showingAlert = true
                                    selectedErrorMessage = .editCollection
                                }
                            }
                        }
                        .disabled(!viewModel.canSubmit)
                    }
                }
            }
            .viewBackgroundColor(HBColor.primaryBackground)
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(ScrollDismissesKeyboardMode.interactively)
        }
        .interactiveDismissDisabled(selectedField != nil ? true : false)
        
    }
    
}

struct NewCollectionViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        
        HabitatPreview {
            NewCollectionViewiOS(editingCollection: nil, editMode: .constant(.active))
            .preferredColorScheme(.light)
        }
    }
}
#endif
