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

public struct NewCollectionView: View {
    
    @ObservedObject private var viewModel: NewCollectionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .error
    @State private var selectedErrorMessage: AlertText = .deleteCollection
    
    public init(
        viewModel: NewCollectionViewModel
    ) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Nome")
                    .font(.callout)
                    .bold()
                TextField("", text: $viewModel.collectionName)
                    .textFieldStyle(CollectionDeckTextFieldStyle())
                Text("Ícones")
                    .font(.callout)
                    .bold()
                
                IconColorGridView {
                    ForEach(viewModel.icons, id: \.self) {icon in
                        Button {
                            viewModel.currentSelectedIcon = icon
                            
                        } label: {
                            Image(systemName: IconNames.getIconString(icon))
                                .frame(width: 45, height: 45)
                        }
                        
                        .buttonStyle(ColorIconButtonStyle(isSelected: viewModel.currentSelectedIcon == icon ? true : false))
                        .frame(width: 45, height: 45)
                    }
                }
                
                Spacer()
                
                if viewModel.editingCollection != nil {
                    Button {
                        activeAlert = .confirm
                        showingAlert = true
                    } label: {
                        Text("Apagar Coleção")
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
                    return Alert(title: Text("Deseja apagar esta coleção?"),
                                 message: Text("Você perderá permanentemente o conteúdo desta coleção."),
                                 primaryButton: .destructive(Text("Apagar")) {
                                    do {
                                        try viewModel.deleteCollection()
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
            .viewBackgroundColor(HBColor.primaryBackground)
            .navigationTitle(viewModel.editingCollection == nil ? "Criar Coleção" : "Editar Coleção")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color.red)
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        
                        if viewModel.editingCollection == nil {
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
                                try viewModel.editCollection()
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
        .navigationViewStyle(.stack)
        
    }
    
}

struct NewCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewCollectionView(
            viewModel: .init(
                collectionRepository: CollectionRepositoryMock()
            ))
        .preferredColorScheme(.light)
        
        
        
    }
}
