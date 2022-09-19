//
//  DetailView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import Models
import HummingBird

public struct DetailView: View {
    
    var decks: [Deck]
    var deleteAction: () -> Void
    
    @Binding private var searchText: String
    @Binding private var detailType: DetailDisplayType
    @Binding private var sortOrder: [KeyPathComparator<Deck>]
    @Binding private var selection: Set<Deck.ID>
    
    @Environment(\.editMode) private var editMode
    
    public init(
        decks: [Deck],
        searchText: Binding<String>,
        detailType: Binding<DetailDisplayType>,
        sortOrder: Binding<[KeyPathComparator<Deck>]>,
        selection: Binding<Set<Deck.ID>>,
        deleteAction: @escaping () -> Void) {
            self.decks = decks
            self.deleteAction = deleteAction
            self._searchText = searchText
            self._detailType = detailType
            self._sortOrder = sortOrder
            self._selection = selection
    }
    
    public var body: some View {
        content
            .searchable(text: $searchText)
            .toolbar(editMode?.wrappedValue.isEditing ?? false ? .visible : .hidden,
                     for: .bottomBar)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Delete", role: .destructive) {
                        deleteAction()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem {
                    Menu {
                        Button {
                            detailType = .grid
                        } label: {
                            Label("Ícones", systemImage: "rectangle.grid.2x2")
                        }
                        .disabled(editMode?.wrappedValue.isEditing ?? false)
                        
                        Button {
                            detailType = .table
                        } label: {
                            Label("Lista", systemImage: "list.bullet")
                        }
                        
                        if detailType == .table {
                            Picker(selection: $sortOrder) {
                                Text("Nome").tag([KeyPathComparator(\Deck.name)])
                                Text("Quantidade de Flashcards").tag([KeyPathComparator(\Deck.cardCount)])
                                Text("Data do Último Acesso").tag([KeyPathComparator(\Deck.datesLogs.lastAccess)])
                            } label: {
                                Text("Opções de ordenação")
                            }
                        }
                        
                    } label: {
                        Image(systemName: detailType == .grid ? "rectangle.grid.2x2" : "list.bullet")
                    }
                }
        
                
                ToolbarItem {
                    EditButton()
                        .foregroundColor(HBColor.actionColor)
                }
                
                ToolbarItem {
                    Button {
                        print("novo deck")
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(HBColor.actionColor)
                    }
                }
            }
            .onChange(of: editMode?.wrappedValue) { newValue in
                if newValue == .active {
                    detailType = .table
                }
            }
            .onChange(of: detailType) { newValue in
                if newValue == .grid {
                    editMode?.wrappedValue = .inactive
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if detailType == .grid {
            DeckGridView(decks: decks)
        } else {
            DeckTableView(decks: decks,
                          sortOrder: $sortOrder,
                          selection: $selection)
        }
    }
}

public enum DetailDisplayType {
    case grid
    case table
}
