//
//  DeckTableView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import Models
import HummingBird
import NewDeckFeature

struct DeckTableView: View {
    @EnvironmentObject private var viewModel: ContentViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var editAction: (Deck) -> Void
    
    private var sortedDecks: [Deck] {
        viewModel.decks.sorted(using: viewModel.sortOrder)
    }
    
    var body: some View {
        if viewModel.decks.isEmpty {
            EmptyStateView(component: .deck)
        } else {
            content
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if horizontalSizeClass == .compact {
            list
        } else {
            table
        }
    }
    
    @ViewBuilder
    private var list: some View {
        List(sortedDecks, selection: $viewModel.selection) { deck in
            NavigationLink(value: StudyRoute.deck(deck)) {
                cell(for: deck)
            }
            .swipeActions {
                Button {
                    try? viewModel.deleteDeck(deck)
                } label: {
                    Text("deletar", bundle: .module)
                }
                .tint(.red)
            }
            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                Button {
                    editAction(deck)
                } label: {
                    Text("editar", bundle: .module)
                }
                .tint(HBColor.actionColor)
            }
            .contextMenu {
                Button {
                    editAction(deck)
                } label: {
                    Label(NSLocalizedString("editar", bundle: .module, comment: ""), systemImage: "pencil")
                }
                
                Button(role: .destructive) {
                    try? viewModel.deleteDeck(deck)
                } label: {
                    Label(NSLocalizedString("deletar", bundle: .module, comment: ""), systemImage: "trash")
                }
            }
        }
        .animation(.linear, value: viewModel.sortOrder)
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private var table: some View {
        Table(sortedDecks, selection: $viewModel.selection, sortOrder: $viewModel.sortOrder) {
            TableColumn("") { deck in
                Image(systemName: deck.icon)
                    .font(.system(size: 14))
                    .foregroundColor(HBColor.color(for: deck.color))
                    .background {
                        Circle()
                            .fill(HBColor.color(for: deck.color).opacity(0.2))
                            .frame(width: 35, height: 35)
                    }
                    .frame(width: 35, height: 35)
            }.width(35)
            TableColumn(NSLocalizedString("nome", bundle: .module, comment: ""), value: \.name) { deck in
                Text(deck.name)
                    .foregroundColor(.primary)
            }
            TableColumn("Flashcards", value: \.cardCount) { deck in
                Text("\(deck.cardCount) flashcards")
            }
            TableColumn(NSLocalizedString("ultimo_acesso", bundle: .module, comment: ""), value: \.datesLogs.lastAccess) { deck in
                Text(deck.datesLogs.lastAccess, style: .date)
            }
            TableColumn(NSLocalizedString("acessar", bundle: .module, comment: "")) { deck in
                NavigationLink(value: StudyRoute.deck(deck)) {
                    Text(NSLocalizedString("abrir", bundle: .module, comment: ""))
                }
                .tint(HBColor.color(for: deck.color))
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
            }.width(90)
        }
        .animation(.linear, value: viewModel.sortOrder)
    }
    
    @ViewBuilder
    private func cell(for deck: Deck) -> some View {
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
