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


public struct DetailView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    @Binding private var editMode: EditMode
    @State private var presentDeckEdition = false
    @State private var shouldDisplayAlert = false
    
    public init(editMode: Binding<EditMode>) {
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
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar(editMode.isEditing ? .visible : .hidden,
                 for: .bottomBar)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    viewModel.editDeck()
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
                    .disabled(editMode.isEditing)
                    
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
            }
        }
        .onChange(of: editMode) { newValue in
            if newValue == .active {
                viewModel.detailType = .table
                viewModel.changeDetailType(for: .table)
            }
        }
        .alert(viewModel.selection.isEmpty ? "Nada foi selecionado" : "Você tem certeza que deseja apagar?", isPresented: $shouldDisplayAlert) {
            Button("Apagar", role: .destructive) {
                try? viewModel.deleteDecks()
            }
            .disabled(viewModel.selection.isEmpty)
            
            Button("Cancelar", role: .cancel) { }
        }
        .onChange(of: presentDeckEdition, perform: viewModel.didDeckPresentationStatusChanged)
        .navigationTitle(viewModel.detailTitle)
        .sheet(isPresented: $presentDeckEdition) {
            NewDeckView(collection: viewModel.selectedCollection, editingDeck: viewModel.editingDeck, editMode: $editMode)
        }
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
                viewModel.updateEditingDeck(with: deck)
                presentDeckEdition = true
            }
        } else {
            DeckTableView()
        }
    }
}
