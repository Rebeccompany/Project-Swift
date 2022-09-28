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
                    if viewModel.collections.isEmpty {
                        emptyState
                            .listRowBackground(Color.clear)
                    } else {
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
                }
                ToolbarItem {
                    Button {
                        viewModel.createCollection()
                        presentCollectionEdition = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .popover(isPresented: $presentCollectionEdition) {
                        NewCollectionView(
                            editingCollection: viewModel.editingCollection
                        )
                        .frame(width: 300, height: 600)
                    }
                }
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
                Text("Criar Coleção")
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
        }
    }
}
