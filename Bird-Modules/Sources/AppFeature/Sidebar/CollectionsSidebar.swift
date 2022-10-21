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
import OnboardingFeature

struct CollectionsSidebar: View {
    @State private var onboarding: Bool = false
    @State private var onboarding: Bool = false
#if os(iOS)
    @Binding private var editMode: EditMode
#endif
    @EnvironmentObject private var viewModel: ContentViewModel
    @Binding private var selection: SidebarRoute?
    @State private var presentCollectionEdition = false
    @State private var presentCollectionCreation = false
    @State private var editingCollection: DeckCollection?
    private var isCompact: Bool
    
    #if os(iOS)
    init(selection: Binding<SidebarRoute?>, isCompact: Bool, editMode: Binding<EditMode>) {
        self._selection = selection
        self._editMode = editMode
        self.isCompact = isCompact
    }
    #elseif os(macOS)
    init(selection: Binding<SidebarRoute?>, isCompact: Bool) {
        self._selection = selection
        self.isCompact = isCompact
    }
    #endif
    
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
                                #if os(iOS)
                                if editMode.isEditing {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(HBColor.actionColor)
                                        .onTapGesture {
                                            editingCollection = collection
                                            presentCollectionEdition = true
                                        }
                                        .accessibility(addTraits: .isButton)
                                }
                                #endif
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
                            } label: {
                                Label(NSLocalizedString("deletar", bundle: .module, comment: ""), systemImage: "trash")
                            }
                        }
                    }
                    .onDelete {
                        try? viewModel.deleteCollection(at: $0)
                        editingCollection = nil
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
                .sheet(isPresented: $onboarding, content: {
                    OnboardingView()
                })
                
            }

            ToolbarItem {
                EditButton()
                    .popover(isPresented: $presentCollectionEdition) {
                        NewCollectionView(
                            editingCollection: editingCollection
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
                    NewCollectionView(
                        editingCollection: editingCollection
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
