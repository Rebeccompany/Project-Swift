//
//  SwiftUIView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models
import NewCollectionFeature
import HummingBird

struct CollectionsSidebar: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var viewModel: ContentViewModel
    @Binding private var selection: SidebarRoute?
    @State private var presentCollectionEdition = false
    private var isCompact: Bool
    
    init(selection: Binding<SidebarRoute?>, isCompact: Bool) {
        self._selection = selection
        self.isCompact = isCompact
    }
    
    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: SidebarRoute.allDecks) {
                Label("Todos os baralhos", systemImage: "square.stack")
            }
            .listRowBackground(
                isCompact ? HBColor.secondaryBackground : nil
            )
            
            Section {
                ForEach(viewModel.collections) { collection in
                    NavigationLink(value: SidebarRoute.decksFromCollection( collection)) {
                        HStack {
                            Label(collection.name, systemImage: collection.icon.rawValue)
                            Spacer()
                            if editMode?.wrappedValue.isEditing ?? false {
                                Image(systemName: "info.circle")
                                    .foregroundColor(HBColor.actionColor)
                                    .onTapGesture {
                                        viewModel.editCollection(collection)
                                        presentCollectionEdition = true
                                    }
                                    .accessibility(addTraits: .isButton)
                            }
                        }
                    }
                    .listRowBackground(
                        isCompact ? HBColor.secondaryBackground : nil
                    )
                    .contextMenu {
                        Button {
                            viewModel.editCollection(collection)
                            presentCollectionEdition = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            try? viewModel.deleteCollection(collection)
                        } label: {
                            Label("Deletar", systemImage: "trash")
                        }
                    }
                }
                .onDelete { try? viewModel.deleteCollection(at: $0) }
                
            } header: {
                Text("Coleções")
            }
        }
        .onChange(of: presentCollectionEdition, perform: viewModel.didCollectionPresentationStatusChanged)
        .scrollContentBackground(.hidden)
        .background(
            VStack {
                if viewModel.collections.isEmpty {
                    VStack {
                        EmptyStateView(component: .collection)
//                        Button {
//#warning("fazer ir pro modal de criar colecao")
//                        } label: {
//                            Text("Criar Coleção")
//                        }
//                        .buttonStyle(LargeButtonStyle(isDisabled: false))
//                        .padding()
                    }
                    
                }
            }
        )
        .viewBackgroundColor(HBColor.primaryBackground)
        .navigationTitle("Nome do App")
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            ToolbarItem {
                Button {
                    viewModel.createCollection()
                    presentCollectionEdition = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $presentCollectionEdition) {
            NewCollectionView(
                viewModel: .init(
                    editingCollection: viewModel.editingCollection
                )
            )
        }
        
    }
    
}
