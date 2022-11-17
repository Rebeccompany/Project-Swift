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
    @State private var presentCollectionCreation = false
    @State private var editingCollection: DeckCollection?
    @Binding private var selection: SidebarRoute
    
    init(selection: Binding<SidebarRoute>) {
        self._selection = selection
    }
    
    var body: some View {
        
        VStack {
            List(selection: $selection) {
                NavigationLink(value: SidebarRoute.allDecks) {
                    Label(NSLocalizedString("todos_os_baralhos", bundle: .module, comment: ""), systemImage: "square.stack")
                }
                Section {
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
                                    presentCollectionCreation = true
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
                    
                } header: {
                    Text(NSLocalizedString("colecoes", bundle: .module, comment: ""))
                }
            }
            
            HStack {
                Button {
                    editingCollection = nil
                    presentCollectionCreation = true
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
        .overlay {
            if viewModel.collections.isEmpty {
                emptyState
            }
        }
        .sheet(isPresented: $presentCollectionCreation) {
            NewCollectionViewMacOS(
                editingCollection: editingCollection
            )
            .frame(minWidth: 600, maxHeight: 500)
        }
        .sheet(isPresented: $onboarding) {
            OnboardingView()
                .frame(minWidth: 400, minHeight: 700)
        }
        .onChange(of: presentCollectionCreation, perform: viewModel.didCollectionPresentationStatusChanged)
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
            }
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            EmptyStateView(component: .collection)
            Button {
                editingCollection = nil
                presentCollectionCreation = true
            } label: {
                Text(NSLocalizedString("criar_colecao", bundle: .module, comment: ""))
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
        }
    }
}
#endif
