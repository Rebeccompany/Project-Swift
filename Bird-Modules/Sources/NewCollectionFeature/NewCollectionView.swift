//
//  SwiftUIView.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import SwiftUI
import HummingBird
import Models
import Storage
import Habitat

public struct NewCollectionView: View {
    
    @StateObject private var viewModel: NewCollectionViewModel = NewCollectionViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State private var selectedErrorMessage: AlertText = .deleteCollection
    @FocusState private var selectedField: Int?
    var editingCollection: DeckCollection?
    
    public init(editingCollection: DeckCollection?) {
        self.editingCollection = editingCollection
    }
    
    public var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Nome")
                        .font(.callout)
                        .bold()
                    TextField("", text: $viewModel.collectionName)
                        .textFieldStyle(CollectionDeckTextFieldStyle())
                        .focused($selectedField, equals: 0)
                    Text("Ícones")
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
                            Text("Apagar Coleção")
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
                                     dismissButton: .default(Text("Fechar")))
                    case .confirm:
                        return Alert(title: Text("Deseja apagar esta coleção?"),
                                     message: Text("Você perderá permanentemente o conteúdo desta coleção."),
                                     primaryButton: .destructive(Text("Apagar")) {
                                        do {
                                            try viewModel.deleteCollection(editingCollection: editingCollection)
                                            dismiss()
                                        } catch {
                                            activeAlert = .error
                                            showingAlert = true
                                            selectedErrorMessage = .deleteCollection
                                        }
                                     },
                                     secondaryButton: .cancel(Text("Cancelar"))
                        )
                    }
                }
                .navigationTitle(editingCollection == nil ? "Criar Coleção" : "Editar Coleção")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Feito") {
                            selectedField = nil
                        }
                        .accessibilityLabel(Text("Botão de feito"))
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") {
                            dismiss()
                        }
                        .foregroundColor(Color.red)
                        
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("OK") {
                            
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
        .navigationViewStyle(.stack)
        
    }
    
}

struct NewCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        
        HabitatPreview {
            NewCollectionView(editingCollection: nil)
            .preferredColorScheme(.light)
        }
        
        
        
    }
}
