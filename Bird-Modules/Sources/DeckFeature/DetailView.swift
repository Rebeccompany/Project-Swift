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
    
    @State var searchText: String = ""
    @State private var sort: Int = 0
    @State private var detailType: DetailDisplayType = .grid
    @State private var sortOrder = [KeyPathComparator(\Deck.name)]
    
    public init(decks: [Deck]) {
        self.decks = decks
    }
    
    public var body: some View {
        content
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button {
                            detailType = .grid
                        } label: {
                            Label("Ícones", systemImage: "rectangle.grid.2x2")
                        }
                        
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
                    Button {
                        print("editar")
                    } label: {
                        EditButton()
                            .foregroundColor(HBColor.actionColor)
                    }
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
    }
    
    @ViewBuilder
    private var content: some View {
        if detailType == .grid {
            DeckGridView(decks: decks)
        } else {
            DeckTableView(decks: decks, sortOrder: $sortOrder)
        }
    }
}

public enum DetailDisplayType {
    case grid
    case table
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(decks: [])
        }
    }
}
