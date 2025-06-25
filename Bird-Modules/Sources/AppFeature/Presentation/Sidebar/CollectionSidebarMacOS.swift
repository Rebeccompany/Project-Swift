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
import StoreState
import Authentication
import StoreFeature

#if os(macOS)
struct CollectionsSidebarMacOS: View {
    @State private var onboarding: Bool = false
    @EnvironmentObject private var viewModel: ContentViewModel
    @EnvironmentObject private var authModel: AuthenticationModel
    @EnvironmentObject private var store: ShopStore
    @EnvironmentObject private var appRouter: AppRouter
    @State private var presentCollectionCreation = false
    @State private var editingCollection: DeckCollection?
    @Binding private var selection: SidebarRoute
    
    init(selection: Binding<SidebarRoute>) {
        self._selection = selection
    }
    
    var body: some View {
        VStack {
            List(selection: $selection) {
                Button { appRouter.sidebarSelection = .allDecks } label: {
                    HStack {
                        Label(NSLocalizedString("baralhos_title", bundle: .module, comment: ""), systemImage: "square.stack")
                            .foregroundColor(appRouter.sidebarSelection == .allDecks ? Color.white : nil)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowBackground( appRouter.sidebarSelection == .allDecks ? Color.accentColor : nil)
                
                Button { appRouter.sidebarSelection = .store } label: {
                    HStack {
                        Label {
                            Text("library", bundle: .module)
                        } icon: {
                            Image(systemName: "books.vertical")
                        }
                        .foregroundColor(appRouter.sidebarSelection == .store ? Color.white : nil)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowBackground( appRouter.sidebarSelection == .store ? Color.accentColor : nil)
                
                Section {
                    ForEach(viewModel.collections) { collection in
                        Button { appRouter.sidebarSelection = .decksFromCollection(collection) } label: {
                            HStack {
                                Label(collection.name, systemImage: collection.icon.rawValue)
                                    .foregroundColor(appRouter.sidebarSelection == .decksFromCollection(collection) ? Color.white : nil)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowBackground( appRouter.sidebarSelection == .decksFromCollection(collection) ? Color.accentColor : nil)
                        
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
                        Text(NSLocalizedString("nova_colecao", bundle: .module, comment: ""))
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
                .frame(minWidth: 400, minHeight: 500)
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
