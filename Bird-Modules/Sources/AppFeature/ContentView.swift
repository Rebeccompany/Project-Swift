//
//  ContentView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models
import CollectionFeature
import NewCollectionFeature
import Storage

public struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var editMode: EditMode = .inactive
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject private var viewModel: ContentViewModel
    @State private var presentCollectionEdition = false
    
    public init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } detail: {
            StudyRouter(
                sidebarSelection: viewModel.sidebarSelection ?? .allDecks
            )
        }
        .onAppear(perform: viewModel.startup)
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $presentCollectionEdition) {
            NewCollectionView(
                viewModel: .init(
                    editingCollection: viewModel.editingCollection
                )
            )
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
