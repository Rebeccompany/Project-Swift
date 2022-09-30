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


struct DetailView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    @Environment(\.editMode) private var editMode
    @State private var presentDeckEdition = false
    @State private var shouldDisplayAlert = false
    
    @State var editingCollection: DeckCollection?
    @State var editingDeck: Deck?
    
    init(editingCollection: DeckCollection?, editingDeck: Deck?) {
        self.editingCollection = editingCollection
        self.editingDeck = editingDeck
    }
    
    var body: some View {
        Group {
            if viewModel.decks.isEmpty {
                emptyState
            } else {
                content
            }
        }
        .searchable(text: $viewModel.searchText)
        .toolbar(editMode?.wrappedValue.isEditing ?? false ? .visible : .hidden,
                 for: .bottomBar)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    editingDeck = viewModel.editDeck()
                    presentDeckEdition = true
                } label: {
                    Text("Editar")
                }
                .disabled(viewModel.selection.count != 1)
                
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button("Deletar", role: .destructive) {
                    shouldDisplayAlert = true
                }
                .foregroundColor(.red)
            }
            
            
            ToolbarItem {
                Menu {
                    Button {
                        viewModel.changeDetailType(for: .grid)
                    } label: {
                        Label("Ícones", systemImage: "rectangle.grid.2x2")
                    }
                    .disabled(editMode?.wrappedValue.isEditing ?? false)
                    
                    Button {
                        viewModel.changeDetailType(for: .table)
                    } label: {
                        Label("Lista", systemImage: "list.bullet")
                    }
                    

                    Picker(selection: $viewModel.sortOrder) {
                        Text("Nome").tag([KeyPathComparator(\Deck.name)])
                        Text("Quantidade de Flashcards").tag([KeyPathComparator(\Deck.cardCount)])
                        Text("Data do Último Acesso").tag([KeyPathComparator(\Deck.datesLogs.lastAccess, order: .reverse)])
                    } label: {
                        Text("Opções de ordenação")
                    }

                    
                } label: {
                    Label {
                        Text("Visualização")
                    } icon: {
                        Image(systemName: viewModel.detailType == .grid ? "rectangle.grid.2x2" : "list.bullet")
                    }
                    
                }
            }
            
            
            ToolbarItem {
                EditButton()
                    .foregroundColor(HBColor.actionColor)
            }
            
            ToolbarItem {
                Button {
                    presentDeckEdition = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(HBColor.actionColor)
                }
                .popover(isPresented: $presentDeckEdition) {
                    NewDeckView(collection: viewModel.selectedCollection, editingDeck: editingDeck)
                    .frame(minWidth: 300, minHeight: 600)
                }
            }
        }
        .onChange(of: editMode?.wrappedValue) { newValue in
            if newValue == .active {
                viewModel.detailType = .table
                viewModel.changeDetailType(for: .table)
            }
        }
        .alert(viewModel.selection.isEmpty ? "Nada foi selecionado" : "Você tem certeza que deseja apagar?", isPresented: $shouldDisplayAlert) {
            Button("Apagar", role: .destructive) {
                try? viewModel.deleteDecks()
                editingDeck = nil
            }
            .disabled(viewModel.selection.isEmpty)
            
            Button("Cancelar", role: .cancel) { }
        }
        .onChange(of: presentDeckEdition, perform: viewModel.didDeckPresentationStatusChanged)
        .navigationTitle(viewModel.detailTitle)
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            EmptyStateView(component: .deck)
            Button {
                presentDeckEdition = true
            } label: {
                Text("Criar Baralho")
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
            DeckTableView()
        }
    }
}
