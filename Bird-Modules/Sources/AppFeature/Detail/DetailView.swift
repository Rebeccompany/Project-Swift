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
import Storage

struct DetailView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    @Environment(\.editMode) private var editMode
    @State private var presentDeckEdition = false
    @State private var shouldDisplayAlert = false
    
    var body: some View {
        content
            .searchable(text: $viewModel.searchText)
            .toolbar(editMode?.wrappedValue.isEditing ?? false ? .visible : .hidden,
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
                            viewModel.detailType = .grid
                        } label: {
                            Label("Ícones", systemImage: "rectangle.grid.2x2")
                        }
                        .disabled(editMode?.wrappedValue.isEditing ?? false)
                        
                        Button {
                            viewModel.detailType = .table
                        } label: {
                            Label("Lista", systemImage: "list.bullet")
                        }
                        
                        if viewModel.detailType == .table {
                            Picker(selection: $viewModel.sortOrder) {
                                Text("Nome").tag([KeyPathComparator(\Deck.name)])
                                Text("Quantidade de Flashcards").tag([KeyPathComparator(\Deck.cardCount)])
                                Text("Data do Último Acesso").tag([KeyPathComparator(\Deck.datesLogs.lastAccess)])
                            } label: {
                                Text("Opções de ordenação")
                            }
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
            .onChange(of: editMode?.wrappedValue) { newValue in
                if newValue == .active {
                    viewModel.detailType = .table
                }
            }
            .onChange(of: viewModel.detailType) { newValue in
                if newValue == .grid {
                    editMode?.wrappedValue = .inactive
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
                NewDeckView(viewModel: NewDeckViewModel(
                    colors: CollectionColor.allCases,
                    icons: IconNames.allCases,
                    editingDeck: viewModel.editingDeck,
                    deckRepository: DeckRepository.shared,
                    collectionRepository: CollectionRepository.shared,
                    collection: viewModel.selectedCollection))
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.detailType == .grid {
            DeckGridView(decks: viewModel.decks) { deck in
//                selection = Set([deck.id])
//                editAction()
            } deleteAction: { deck in
//                selection = Set([deck.id])
//                deleteAction()
            }
        } else {
            DeckTableView(decks: viewModel.decks,
                          sortOrder: $viewModel.sortOrder,
                          selection: $viewModel.selection)
            
        }
    }
}

public enum DetailDisplayType {
    case grid
    case table
}
