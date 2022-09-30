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
    @State private var presentCollectionCreation = false
    @State private var editingCollection: DeckCollection? = nil
    private var isCompact: Bool
    
    init(selection: Binding<SidebarRoute?>, isCompact: Bool, editMode: Binding<EditMode>) {
        self._selection = selection
        self._editMode = editMode
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
                                            editingCollection = collection
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
                                editingCollection = collection
                                presentCollectionEdition = true
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                try? viewModel.deleteCollection(collection)
                                editingCollection = nil
                            } label: {
                                Label("Deletar", systemImage: "trash")
                            }
                        }
                    }
                    .onDelete {
                        try? viewModel.deleteCollection(at: $0)
                        editingCollection = nil
                    }
                }
                
            } header: {
                Text("Coleções")
            }
        }
        .onChange(of: presentCollectionEdition, perform: viewModel.didCollectionPresentationStatusChanged)
        .scrollContentBackground(.hidden)
        .viewBackgroundColor(HBColor.primaryBackground)
        .navigationTitle("Spixii")
        .toolbar {
            ToolbarItem {
                EditButton()
                    .popover(isPresented: $presentCollectionEdition) {
                        NewCollectionView(
                            editingCollection: editingCollection, editMode: $editMode
                        )
                        .frame(minWidth: 300, minHeight: 600)
                    }
            }
            ToolbarItem {
                Button {
                    editingCollection = nil
                } label: {
                    Image(systemName: "plus")
                }
                .popover(isPresented: $presentCollectionCreation) {
                    NewCollectionView(
                        editingCollection: editingCollection, editMode: $editMode
                    )
                    .frame(minWidth: 300, minHeight: 600)
                }
            }
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            EmptyStateView(component: .collection)
            Button {
                editingCollection = nil
                presentCollectionEdition = true
            } label: {
                Text("Criar Coleção")
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
        }
    }
}
