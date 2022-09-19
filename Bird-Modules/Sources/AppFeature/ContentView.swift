//
//  ContentView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models
import CollectionFeature
import DeckFeature
import HummingBird
import Flock
import NewCollectionFeature
import Storage

public struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var editMode: EditMode = .inactive
    @State private var presentCollectionEdition = false
    @State private var path: NavigationPath = .init()
    @State private var shouldDisplayAlert = false
    
    @ObservedObject private var viewModel: ContentViewModel
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    public init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } detail: {
            Router(path: $path) {
                DetailView(
                    decks: viewModel.decks,
                    searchText: $viewModel.searchText,
                    detailType: $viewModel.detailType,
                    sortOrder: $viewModel.sortOrder,
                    selection: $viewModel.selection) {
                        shouldDisplayAlert = true
                    }
            } destination: { (route: StudyRoute) in
                StudyRoutes.destination(for: route)
            }
        }
        .onAppear(perform: viewModel.startup)
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $presentCollectionEdition) {
            NewCollectionView(
                viewModel: .init(
                    colors: CollectionColor.allCases,
                    editingCollection: viewModel.editingCollection
                )
            )
        }
        .alert(viewModel.selection.isEmpty ? "Nada foi selecionado" : "Você tem certeza que deseja apagar?", isPresented: $shouldDisplayAlert) {
            Button("Apagar", role: .destructive) {
                viewModel.deleteDecks()
            }
            .disabled(viewModel.selection.isEmpty)
            
            Button("Cancelar", role: .cancel) { }
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebar(
            collections: viewModel.collections,
            selection: $viewModel.sidebarSelection,
            isCompact: horizontalSizeClass == .compact
        ) { i in
            try? viewModel.deleteCollection(at: i)
        } editAction: { collection in
            viewModel.editCollection(collection)
            presentCollectionEdition = true
        }
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
                        Image(systemName: "folder.badge.plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
    }
    
    @ViewBuilder
    private var detail: some View {
        Text("oi")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                collectionRepository: CollectionRepositoryMock.shared,
                deckRepository: DeckRepositoryMock.shared
            )
        )
    }
}
