//
//  CollectionsSidebariOS.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models
import NewCollectionFeature
import HummingBird
import OnboardingFeature

#if os(iOS)
struct CollectionsSidebariOS: View {
    @State private var onboarding: Bool = false
    @Binding private var editMode: EditMode
    @EnvironmentObject private var viewModel: ContentViewModel
    @State private var presentCollectionEdition = false
    @State private var presentCollectionCreation = false
    @State private var editingCollection: DeckCollection?
    @Binding private var selection: SidebarRoute?
    private var isCompact: Bool
    
    init(isCompact: Bool, editMode: Binding<EditMode>, selection: Binding<SidebarRoute?>) {
        self._editMode = editMode
        self.isCompact = isCompact
        self._selection = selection
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
                                Label(NSLocalizedString("editar", bundle: .module, comment: ""), systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                try? viewModel.deleteCollection(collection)
                                editingCollection = nil
                                selection = .allDecks
                            } label: {
                                Label(NSLocalizedString("deletar", bundle: .module, comment: ""), systemImage: "trash")
                            }
                        }
                    }
                    .onDelete {
                        try? viewModel.deleteCollection(at: $0)
                        editingCollection = nil
                        selection = .allDecks
                    }
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
                Button {
                    onboarding = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(HBColor.actionColor)
                        .accessibility(addTraits: .isButton)
                }
                .sheet(isPresented: $onboarding) {
                    OnboardingView()
                }
            }
            
            ToolbarItem {
                EditButton()
                    .popover(isPresented: $presentCollectionEdition) {
                        NewCollectionViewiOS(
                            editingCollection: editingCollection, editMode: $editMode
                        )
                        .frame(minWidth: 300, minHeight: 600)
                    }
            }
            
            ToolbarItem {
                Button {
                    editingCollection = nil
                    presentCollectionCreation = true
                } label: {
                    Image(systemName: "plus")
                }
                .popover(isPresented: $presentCollectionCreation) {
                    NewCollectionViewiOS(
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
                Text(NSLocalizedString("criar_colecao", bundle: .module, comment: ""))
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
        }
    }
}
#endif
