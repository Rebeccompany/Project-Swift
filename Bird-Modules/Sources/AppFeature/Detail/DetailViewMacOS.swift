//
//  DetailViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 26/10/22.
//

import SwiftUI
import Models
import HummingBird
import NewDeckFeature
import DeckFeature
import Storage
import Habitat

#if os(macOS)
public struct DetailViewMacOS: View {
    @EnvironmentObject private var viewModel: ContentViewModel
    @State private var presentDeckCreation = false
    @State private var shouldDisplayAlert = false
    @State private var editingDeck: Deck?
    
    public var body: some View {
        Group {
            if viewModel.decks.isEmpty {
                emptyState
            } else {
                content
            }
        }
        .searchable(text: $viewModel.searchText)
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.changeDetailType(for: .grid)
                } label: {
                    Label {
                        Text(NSLocalizedString("visualizacao", bundle: .module, comment: ""))
                    } icon: {
                        Image(systemName: "rectangle.grid.2x2")
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(viewModel.detailType == .grid ? 0.05 : 0))
                )
            }
            
            ToolbarItem {
                Button {
                    viewModel.changeDetailType(for: .table)
                } label: {
                    Image(systemName: "list.bullet")
                }.background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(viewModel.detailType == .table ? 0.05 : 0))
                )
            }
            
            ToolbarItem {
                Menu {
                    
                    Button(NSLocalizedString("nome", bundle: .module, comment: "")) {
                        viewModel.sortOrder = [KeyPathComparator(\Deck.name)]
                    }
                    
                    Button(NSLocalizedString("quantidade", bundle: .module, comment: "")) {
                        viewModel.sortOrder = [KeyPathComparator(\Deck.cardCount)]
                    }
                    
                    Button(NSLocalizedString("ultimo_acesso", bundle: .module, comment: "")) {
                        viewModel.sortOrder = [KeyPathComparator(\Deck.datesLogs.lastAccess)]
                    }
                    
                } label: {
                    
                    if viewModel.sortOrder == [KeyPathComparator(\Deck.name)] {
                        Text("Nome")
                    } else if viewModel.sortOrder == [KeyPathComparator(\Deck.cardCount)] {
                        Text("Quantidade")
                    } else if viewModel.sortOrder == [KeyPathComparator(\Deck.datesLogs.lastAccess)] {
                        Text("Último Acesso")
                    }
                }
            }
            
            ToolbarItem {
                Button {
                    editingDeck = nil
                    presentDeckCreation = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(HBColor.actionColor)
                }
                .sheet(isPresented: $presentDeckCreation) {
                    NewDeckViewMacOS(collection: viewModel.selectedCollection, editingDeck: editingDeck)
                        .frame(minWidth: 300, minHeight: 600)
                }
            }
        }
        .alert(viewModel.selection.isEmpty ? NSLocalizedString("alert_nada_selecionado", bundle: .module, comment: "") : NSLocalizedString("alert_confirmacao_deletar", bundle: .module, comment: ""), isPresented: $shouldDisplayAlert) {
            Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                try? viewModel.deleteDecks()
                editingDeck = nil
            }
            .disabled(viewModel.selection.isEmpty)
            
            Button(NSLocalizedString("cancelar", bundle: .module, comment: ""), role: .cancel) { }
        }
        .onChange(of: presentDeckCreation, perform: viewModel.didDeckPresentationStatusChanged)
        .navigationTitle(viewModel.detailTitle)
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            EmptyStateView(component: .deck)
            Button {
                editingDeck = nil
                presentDeckCreation = true
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
                presentDeckCreation = true
            }
        } else {
            DeckTableView { deck in
                editingDeck = deck
                presentDeckCreation = true
            }
        }
    }
}
#endif
