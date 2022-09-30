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
    @Binding private var editMode: EditMode
    @EnvironmentObject private var viewModel: ContentViewModel
    @Binding private var selection: SidebarRoute?
    @State private var presentCollectionEdition = false
    private var isCompact: Bool
    
    init(selection: Binding<SidebarRoute?>, isCompact: Bool, editMode: Binding<EditMode>) {
        self._selection = selection
        self._editMode = editMode
        self.isCompact = isCompact
    }
    
    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: SidebarRoute.allDecks) {
                Label(NSLocalizedString("todos_os_baralhos", bundle: .module, comment: ""), systemImage: "square.stack")
            }
            .listRowBackground(
                isCompact ? HBColor.secondaryBackground : nil
            )
            
            Section {
                if viewModel.collections.isEmpty {
                    emptyState
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.collections) { collection in
                        NavigationLink(value: SidebarRoute.decksFromCollection( collection)) {
                            HStack {
                                Label(collection.name, systemImage: collection.icon.rawValue)
                                Spacer()
                                if editMode.isEditing {
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
                                Label(NSLocalizedString("editar", bundle: .module, comment: ""), systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                try? viewModel.deleteCollection(collection)
                            } label: {
                                Label(NSLocalizedString("deletar", bundle: .module, comment: ""), systemImage: "trash")
                            }
                        }
                    }
                    .onDelete { try? viewModel.deleteCollection(at: $0) }
                }
                
            } header: {
                Text(NSLocalizedString("colecoes", bundle: .module, comment: ""))
            }
        }
        .onChange(of: presentCollectionEdition, perform: viewModel.didCollectionPresentationStatusChanged)
        .scrollContentBackground(.hidden)
        .viewBackgroundColor(HBColor.primaryBackground)
        .navigationTitle("Spixii")
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
                editingCollection: viewModel.editingCollection,
                editMode: $editMode
            )
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            EmptyStateView(component: .collection)
            Button {
                viewModel.createCollection()
                presentCollectionEdition = true
            } label: {
                Text(NSLocalizedString("criar_colecao", bundle: .module, comment: ""))
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
        }
    }
}
