//
//  DeckView.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 21/06/25.
//

import SwiftUI
import Models
import HummingBird
import NewFlashcardFeature
import StudyFeature

public struct DeckView: View {
    @State private var model: DeckViewModel
    @State private var scrollAfterHeader = false


    public init(deckBinding: Binding<Deck>) {
        model = DeckViewModel(deckBinding: deckBinding)
    }

    public var body: some View {
        ScrollView {
            LazyVStack {
                DeckHeader(deck: model.deck)
                    .onScrollVisibilityChange { isVisible in
                        scrollAfterHeader = !isVisible
                    }
                Section {
                    LazyVGrid(
                        columns: [
                            GridItem(
                                .adaptive(minimum: 160, maximum: 180),
                                spacing: 12,
                                alignment: .top
                            )
                        ],
                        spacing: 12,
                        pinnedViews: .sectionFooters
                    ) {
                        ForEach(model.state.filteredCards) { card in
                            DeckCard(card: card, model: model)
                        }
                    }
                } header: {
                    HStack {
                        Text("Cards")
                            .font(.headline.bold())
                        Spacer()
                        Text("\(model.state.cards.count) cartas")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                }.padding()

            }
        }
        .toolbar {
            topBar()
            bottomBar()
        }
        .ignoresSafeArea(edges: .top)
        .searchable(text: $model.state.filterValue)
        .sheet(item: $model.state.sheetRoute, content: sheet(for:))
        .fullScreenCover(item: $model.state.fullScreenRoute, content: cover(for:))
        .onAppear(perform: model.startup)
        .animation(.snappy, value: model.state.filteredCards)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(scrollAfterHeader ? model.deck.name : "")
    }

    @ToolbarContentBuilder
    private func bottomBar() -> some ToolbarContent {
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        ToolbarSpacer(UIDevice.current.userInterfaceIdiom == .phone ? .fixed : .flexible, placement: .bottomBar)
        ToolbarItem(placement: .bottomBar) {
            Menu("Estudar", systemImage: "studentdesk") {
                Button("Spixii", systemImage: "studentdesk") {
                    model.presentCover(for: .study(.spaced))
                }
                    .disabled(!model.state.canUseSpixiiMode)
                Button("Intese", systemImage: "flame") {
                    model.presentCover(for: .study(.cramming))
                }
            }
            .buttonStyle(.glass)
            .menuStyle(.button)
            .buttonBorderShape(.circle)
            .tint(HBColor.color(for: model.deck.color))
        }
    }

    @ToolbarContentBuilder
    private func topBar() -> some ToolbarContent {
        ToolbarItemGroup {
            Button {
                model.presentSheet(for: .importCards)
            } label: {
                Label("Importar", systemImage: "arrow.down")
            }.tint(HBColor.white)

            Button {
                model.presentSheet(for: .addCard)
            } label: {
                Label("Adicionar", systemImage: "plus")
            }.tint(HBColor.white)
        }
    }

    @ViewBuilder
    private func sheet(for route: DeckSheetRoute) -> some View {
        switch route {
        case .addCard:
            NewFlashcardViewiOS(deck: model.deck)
        case .importCards:
            Text("")
        case let .editCard(card):
            NewFlashcardViewiOS(deck: model.deck, editingFlashcard: card)
        }
    }

    @ViewBuilder
    private func cover(for route: DeckFullScreenRoute) -> some View {
        switch route {
        case .study(let studyMode):
            StudyViewiOS(deck: model.deck, mode: studyMode)
        }
    }
}


#Preview {
    NavigationStack {
        DeckView(
            deckBinding:
                    .constant(
                        Deck(
                            id: .init(),
                            name: "Swift",
                            icon: "swift",
                            color: .lightBlue,
                            collectionId: nil,
                            cardsIds: [],
                            category: .humanities,
                            storeId: nil,
                            description: "",
                            ownerId: nil
                        )
                    )
        )
    }
}
