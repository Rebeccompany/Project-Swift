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
import StoreFeature
import Authentication
import OnboardingFeature
import StoreState

#if os(iOS)
struct CollectionsSidebariOS: View {
    @State private var onboarding: Bool = false
    @State private var presentCollectionEdition = false
    @State private var presentCollectionCreation = false
    @State private var editingCollection: DeckCollection?
    @Binding private var editMode: EditMode
    @Binding private var selection: SidebarRoute?
    @EnvironmentObject private var viewModel: ContentViewModel
    @EnvironmentObject private var store: ShopStore
    @EnvironmentObject private var authModel: AuthenticationModel
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }
    
    init(selection: Binding<SidebarRoute?>, editMode: Binding<EditMode>) {
        self._selection = selection
        self._editMode = editMode
    }
    
    var body: some View {
        
        List(selection: $selection) {
            NavigationLink(value: SidebarRoute.allDecks) {
                Label(NSLocalizedString("baralhos_title", bundle: .module, comment: ""), systemImage: "square.stack")
            }
            .listRowBackground(
                isCompact ? HBColor.secondaryBackground : nil
            )
            
            if !isCompact {
                NavigationLink {
                    NavigationStack {
                        StoreView(store: store)
                            .environmentObject(authModel)
                    }
                } label: {
                    Label("Store", systemImage: "bag")
                }
                .listRowBackground(
                    isCompact ? HBColor.secondaryBackground : nil
                )

            }
            
            Section {
                if viewModel.collections.isEmpty {
                    emptyState
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.collections) { collection in
                        NavigationLink(value: SidebarRoute.decksFromCollection(collection)) {
                            HStack {
                                Label(collection.name, systemImage: collection.icon.rawValue)
                                Spacer()
                                if editMode.isEditing {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(HBColor.actionColor)
                                        .onTapGesture {
                                            editCollection(editingCollection: collection)
                                        }
                                        .accessibility(addTraits: .isButton)
                                }
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                editCollection(editingCollection: collection)
                            } label: {
                                Text("editar", bundle: .module)
                            }
                            .tint(HBColor.actionColor)
                        }
                        .listRowBackground(
                            isCompact ? HBColor.secondaryBackground : nil
                        )
                        .contextMenu {
                            Button {
                                editCollection(editingCollection: collection)
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
        .sheet(isPresented: $onboarding) {
            OnboardingView()
        }
        .onChange(of: presentCollectionEdition, perform: viewModel.didCollectionPresentationStatusChanged)
        .scrollContentBackground(.hidden)
        .viewBackgroundColor(HBColor.primaryBackground)
        .navigationTitle(NSLocalizedString("colecoes_title", bundle: .module, comment: ""))
        .toolbar {
            ToolbarItem {
                Button {
                    onboarding = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(HBColor.actionColor)
                        .accessibility(addTraits: .isButton)
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
                    editCollection(editingCollection: nil)
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
                editCollection(editingCollection: nil)
            } label: {
                Text(NSLocalizedString("criar_colecao", bundle: .module, comment: ""))
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
        }
    }
    
    private func editCollection(editingCollection: DeckCollection?) {
        self.editingCollection = editingCollection
        presentCollectionEdition = true
    }
}
#endif
