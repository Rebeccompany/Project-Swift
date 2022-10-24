//
//  CollectionSidebarMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 24/10/22.
//

import SwiftUI
import Models
import NewCollectionFeature
import HummingBird
import OnboardingFeature

#if os(macOS)
struct CollectionsSidebarMacOS: View {
    @State private var onboarding: Bool = false
    @EnvironmentObject private var viewModel: ContentViewModel
    @Binding private var selection: SidebarRoute?
    @State private var presentCollectionEdition = false
    @State private var presentCollectionCreation = false
    @State private var editingCollection: DeckCollection?
    
    init(selection: Binding<SidebarRoute?>) {
        self._selection = selection
    }
    
    var body: some View {
        
        List(selection: $selection) {
            NavigationLink(value: SidebarRoute.allDecks) {
                Label(NSLocalizedString("todos_os_baralhos", bundle: .module, comment: ""), systemImage: "square.stack")
            }
            
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
                            }
                        }
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
                        .frame(minWidth: 400, minHeight: 700)
                })
                
            }
        }
    
        HStack {
            Button {
                print("oi")
            } label: {
                Label {
                    Text("Nova Coleção")
                } icon: {
                    Image(systemName: "plus.circle")
                }
                .font(.system(size: 14))
            }
            .buttonStyle(PlainButtonStyle())
            .tint(HBColor.newCollectionSidebar)
            
            Spacer()
        }
        .padding([.bottom, .leading], 12)
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
