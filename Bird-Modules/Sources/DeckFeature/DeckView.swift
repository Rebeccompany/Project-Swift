//
//  DeckView.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 21/06/25.
//

import SwiftUI
import Models
import HummingBird

struct DeckView: View {
    @State private var model = DeckModel()
    @State private var searchValue = ""

    var body: some View {
        ScrollView {
            LazyVStack {
                DeckHeader(deck: model.deck)
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
                        ForEach(model.cards) { card in
                            FlashcardCell(card: card) {

                            }
                            .frame(height: 230)
                        }
                    }
                } header: {
                    HStack {
                        Text("Cards")
                            .font(.headline.bold())
                        Spacer()
                        Text("\(model.cards.count) cartas")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }

            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button {

                } label: {
                    Label("Importar", systemImage: "arrow.down")
                }.tint(HBColor.white)

                Button {

                } label: {
                    Label("Adicionar", systemImage: "plus")
                }.tint(HBColor.white)
            }

            DefaultToolbarItem(kind: .search, placement: .bottomBar)
            ToolbarSpacer(.fixed, placement: .bottomBar)
            ToolbarItem(placement: .bottomBar) {
                Menu("Estudar", systemImage: "studentdesk") {
                    Button("Spixii", systemImage: "studentdesk") {}
                    Button("Intese", systemImage: "flame") {}
                }
                .buttonStyle(.glass)
                .menuStyle(.button)
                .buttonBorderShape(.circle)
                .tint(HBColor.color(for: model.deck.color))
            }
        }
        .ignoresSafeArea(edges: .top)
        .searchable(text: $searchValue, placement: .toolbarPrincipal)
    }


}

struct DeckHeader: View {
    let deck: Deck

    var body: some View {
        ZStack(alignment:.bottomLeading) {
            symbol(size: .init(width: 50, height: 50), name: deck.icon, renderingMode: .original)
                .resizable(resizingMode: .tile)
                .font(.system(size: 35))
                .frame(height: 300)
                .foregroundStyle(HBColor.color(for: deck.color).mix(with: .white, by: 0.3))
                .background(HBColor.color(for: deck.color))
                .backgroundExtensionEffect()

            VStack(alignment: .leading, spacing: 4) {
                Text(deck.name)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)

                if !deck.description.isEmpty {
                    Text(deck.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .glassEffect(
                .regular.interactive(false).tint(.clear),
                in: UnevenRoundedRectangle(topLeadingRadius: 8, topTrailingRadius: 8),
                isEnabled: true
            )
        }
    }

    private func symbol(size: CGSize, name: String, renderingMode: Image.TemplateRenderingMode) -> Image {
        Image(size: size) { context in
            let symbol = Image(systemName: name).renderingMode(renderingMode)
            context.draw(symbol, at: .init(x: size.width / 2, y: size.height / 2), anchor: .center)
        }
    }
}

@Observable
final class DeckModel {
    var deck: Deck = Deck(
        id: .init(),
        name: "WWDC 2025",
        icon: "book.closed",
        color: .darkPurple,
        collectionId: nil,
        cardsIds: [],
        category: DeckCategory.humanities,
        storeId: nil,
        description: "Descubra tudo que a WWDC 2025 tem de novidade",
        ownerId: nil
    )

    var cards: [Card] = Array(
        repeating: (),
        count: 30
    ).map { _ in
        Card(
            id: .init(),
            front: .init(string: "Craig Federighi is??"),
            back: .init(string: "Beaultiful"),
            color: .darkPurple,
            datesLogs: .init(),
            deckID: .init(),
            woodpeckerCardInfo: .init(hasBeenPresented: false),
            history: []
        )
    }
}

#Preview {
    NavigationStack {
        DeckView()
    }
}
