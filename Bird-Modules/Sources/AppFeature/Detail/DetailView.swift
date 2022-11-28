//
//  DetailView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import Models
import HummingBird
import NewDeckFeature
import DeckFeature
import Storage
import Habitat
import Tweet


public struct DetailView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    @Binding private var editMode: EditMode
    @State private var presentDeckEdition = false
    @State private var shouldDisplayAlert = false
    @State private var editingDeck: Deck?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    
    init(editMode: Binding<EditMode>) {
        self._editMode = editMode
    }
    
    public var body: some View {
        Group {
            if viewModel.decks.isEmpty {
                emptyState
            } else {
                content
            }
        }
        .searchable(text: $viewModel.searchText, placement: horizontalSizeClass == .compact ? .navigationBarDrawer(displayMode: .always) : .toolbar)
        .toolbar(editMode.isEditing ? .visible : .hidden,
                 for: .bottomBar)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    editingDeck = viewModel.editDeck()
                    presentDeckEdition = true
                } label: {
                    Text(NSLocalizedString("editar", bundle: .module, comment: ""))
                }
                .disabled(viewModel.selection.count != 1)
                
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                    shouldDisplayAlert = true
                }
                .foregroundColor(.red)
                .confirmationDialog("Are you sure?", isPresented: $shouldDisplayAlert) {
                    Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                        try? viewModel.deleteDecks()
                        editingDeck = nil
                    }
                    .disabled(viewModel.selection.isEmpty)
                } message: {
                    Text(viewModel.selection.isEmpty ? NSLocalizedString("alert_nada_selecionado", bundle: .module, comment: "") : NSLocalizedString("alert_confirmacao_deletar", bundle: .module, comment: ""))
                }
            }
            
            
            ToolbarItem {
                Menu {
                    Button {
                        viewModel.changeDetailType(for: .grid)
                        viewModel.shouldReturnToGrid = true
                    } label: {
                        Label(NSLocalizedString("icones", bundle: .module, comment: ""), systemImage: "rectangle.grid.2x2")
                    }
                    .disabled(editMode.isEditing)
                    
                    Button {
                        viewModel.changeDetailType(for: .table)
                        viewModel.shouldReturnToGrid = false
                    } label: {
                        Label(NSLocalizedString("lista", bundle: .module, comment: ""), systemImage: "list.bullet")
                    }
                    
                    Picker(selection: $viewModel.sortOrder) {
                        Text(NSLocalizedString("nome", bundle: .module, comment: "")).tag([KeyPathComparator(\Deck.name)])
                        Text(NSLocalizedString("quantidade", bundle: .module, comment: "")).tag([KeyPathComparator(\Deck.cardCount)])
                        Text(NSLocalizedString("ultimo_acesso", bundle: .module, comment: "")).tag([KeyPathComparator(\Deck.datesLogs.lastAccess, order: .reverse)])
                    } label: {
                        Text(NSLocalizedString("opcoes_ordenacao", bundle: .module, comment: ""))
                    }
                    
                } label: {
                    Label {
                        Text(NSLocalizedString("visualizacao", bundle: .module, comment: ""))
                    } icon: {
                        Image(systemName: viewModel.detailType == .grid ? "rectangle.grid.2x2" : "list.bullet")
                    }
                }
            }
            
            ToolbarItem {
                EditButton()
                    .keyboardShortcut("e", modifiers: .command)
                    .foregroundColor(HBColor.actionColor)
            }
            
            ToolbarItem {
                Button {
                    editingDeck = nil
                    presentDeckEdition = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(HBColor.actionColor)
                }
                .popover(isPresented: $presentDeckEdition) {
                    NewDeckView(collection: viewModel.selectedCollection, editingDeck: editingDeck, editMode: $editMode)
                        .frame(minWidth: 300, minHeight: 600)
                }
            }
        }
        .onChange(of: editMode) { newValue in
            if newValue == .active {
                viewModel.changeDetailType(for: .table)
            } else if viewModel.shouldReturnToGrid {
                viewModel.changeDetailType(for: .grid)
            }
        }
        .onChange(of: presentDeckEdition, perform: viewModel.didDeckPresentationStatusChanged)
        .navigationTitle(viewModel.detailTitle)
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            EmptyStateView(component: .deck)
            Button {
                editingDeck = nil
                presentDeckEdition = true
            } label: {
                Text(NSLocalizedString("criar_baralho", bundle: .module, comment: ""))
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.detailType == .grid {
            DeckGridView { deck in
                editingDeck = deck
                presentDeckEdition = true
            }
        } else {
            DeckTableView { deck in
                editingDeck = deck
                presentDeckEdition = true
            }
        }
    }
}
