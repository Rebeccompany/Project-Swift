//
//  ContentView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models
import CollectionFeature
import Storage

public struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var editMode: EditMode = .inactive
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject private var viewModel: ContentViewModel
    
    public init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            CollectionsSidebar(
                collections: viewModel.collections,
                selection: $viewModel.sidebarSelection,
                isCompact: horizontalSizeClass == .compact
            ) { _ in } editAction: { _ in }
                .navigationTitle("Nome do App")
                .toolbar {
                    ToolbarItem {
                        EditButton()
                    }
                    ToolbarItem {
                        Button {
                            
                        } label: {
                            Image(systemName: "folder.badge.plus")
                        }
                    }
                }
                .environment(\.editMode, $editMode)
        } detail: {
            switch viewModel.sidebarSelection ?? .allDecks {
            case .allDecks:
                Text(horizontalSizeClass == .compact ? "si" : "no")
            case .decksFromCollection(let id):
                Text("id: \(id.uuidString)")
            }
        }
        .onAppear(perform: viewModel.startup)
        .navigationSplitViewStyle(.balanced)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                collectionRepository: CollectionRepositoryMock(),
                deckRepository: DeckRepositoryMock()
            )
        )
    }
}
