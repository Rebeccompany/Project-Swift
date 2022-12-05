//
//  DeckGridView.swift
//  
//
//  Created by Nathalia do Valle Papst on 15/09/22.
//

import SwiftUI
import HummingBird
import Models

struct DeckGridView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    var editAction: (Deck) -> Void
    @State private var shouldDisplayAlert = false
    @State private var deckToBeDeleted: Deck?
    
    @State private var deckToBeEdited: Deck?
    @State private var isCollectionSheetPresented = false
    
    private var sortedDecks: [Deck] {
        viewModel.filteredDecks.sorted(using: viewModel.sortOrder)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                if !viewModel.todayDecks.isEmpty && viewModel.selectedCollection == nil {
                    Text(NSLocalizedString("sessões_para_hoje", bundle: .module, comment: ""))
                        .padding(.leading)
                    #if os(macOS)
                        .padding(.top)
                    #endif
                        .font(.title3)
                        .bold()
                    SessionsForTodayView()
                }
                Text(NSLocalizedString("baralhos", bundle: .module, comment: ""))
                    .padding(.leading)
                    .padding(.top)
                    .font(.title3)
                    .bold()
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 24, alignment: .top)], spacing: 24) {
                    ForEach(sortedDecks) { deck in
                        NavigationLink(value: StudyRoute.deck(deck)) {
                            DeckCell(info: DeckCellInfo(deck: deck))
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
                                    
                                    Button {
                                        deckToBeEdited = deck
                                        isCollectionSheetPresented = true
                                    } label: {
                                        Label(NSLocalizedString("mover_colecao", bundle: .module, comment: ""), systemImage: "tray.and.arrow.down")
                                    }
                                }
                        }
                        .buttonStyle(DeckCell.Style(color: deck.color))
#if os(iOS)
                        .hoverEffect(.lift)
#endif
                        .confirmationDialog("Are you sure?", isPresented: $shouldDisplayAlert) {
                            Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                                guard let deckToBeDeleted else { return }
                                try? viewModel.deleteDeck(deckToBeDeleted)
                            }
                        } message: {
                            Text(NSLocalizedString("alert_confirmacao_deletar", bundle: .module, comment: ""))
                        }
                    }
                    #if os(iOS)
                    .hoverEffect()
                    .padding(2)
                    #endif
                    .confirmationDialog("Are you sure?", isPresented: $shouldDisplayAlert) {
                        Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                            guard let deckToBeDeleted else { return }
                            try? viewModel.deleteDeck(deckToBeDeleted)
                        }
                    } message: {
                        Text(NSLocalizedString("alert_confirmacao_deletar", bundle: .module, comment: ""))
                    }
                }
                .animation(.linear, value: viewModel.sortOrder)
                .padding([.horizontal], 12)
                .padding(.top, 24)
            }
            .sheet(isPresented: $isCollectionSheetPresented) {
                CollectionList(viewModel: viewModel, deck: $deckToBeEdited)
            }
        }
    }
}
