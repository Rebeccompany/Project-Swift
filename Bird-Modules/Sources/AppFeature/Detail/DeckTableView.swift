//
//  DeckTableView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import Models
import HummingBird

struct DeckTableView: View {
    @EnvironmentObject private var viewModel: ContentViewModel
    
    private var sortedDecks: [Deck] {
        viewModel.decks.sorted(using: viewModel.sortOrder)
    }
    
    var body: some View {
        if viewModel.decks.isEmpty {
            EmptyStateView(component: .deck)
        } else {
            table
        }
    }
    
    @ViewBuilder
    private var table: some View {
        Table(sortedDecks, selection: $viewModel.selection, sortOrder: $viewModel.sortOrder) {
            TableColumn("Nome", value: \.name) { deck in
                NavigationLink(value: deck) {
                    HStack {
                        Image(systemName: deck.icon)
                            .foregroundColor(HBColor.color(for: deck.color))
                            .background(
                                Circle()
                                    .fill(HBColor.color(for: deck.color).opacity(0.2))
                                
                                    .frame(width: 35, height: 35)
                                    
                            )
                            .frame(width: 35, height: 35)
                            .padding(.trailing, 8)
                        Text(deck.name)
                            .foregroundColor(.primary)
                    }
                    .padding(.leading, 4)
                }
            }
            TableColumn("Flashcards", value: \.cardCount) { deck in
                Text("\(deck.cardCount) flashcards")
            }
            TableColumn("Último Acesso", value: \.datesLogs.lastAccess) { deck in
                Text(deck.datesLogs.lastAccess, style: .date)
            }
        }
        .animation(.linear, value: viewModel.sortOrder)
    }
}
