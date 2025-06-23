//
//  DeckViewModel.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 23/06/25.
//
import Models
import Storage
import Habitat
import SwiftUI

struct DeckState {
    var sheetRoute: DeckSheetRoute?
    var fullScreenRoute: DeckFullScreenRoute?
    var cards: [Card] = []
    var filterValue: String = ""
    var canUseSpixiiMode: Bool = false

    var filteredCards: [Card] {
        if filterValue.isEmpty {
            return cards
        } else {
            if let filteredCards = try? cards.filter(#Predicate<Card> {
                $0.front.string.capitalized.contains(filterValue.capitalized) || $0.back.string.capitalized.contains(filterValue.capitalized)
            }) {
                return filteredCards
            }
            return cards
        }
    }
}

@Observable
final class DeckViewModel {
    var deck: Deck {
        deckBinding.wrappedValue
    }

    var state: DeckState = DeckState()
    private(set) var deckBinding: Binding<Deck>

    private let interactor = DeckInteractor()

    init(deckBinding: Binding<Deck>) {
        self._deckBinding = deckBinding
    }

    func startup() {
        Task {
            do {
                try await cardListener()
            } catch {}
        }
        state.canUseSpixiiMode = interactor.canStudySpixiiMode(for: deck)
    }

    private func cardListener() async throws {
        for try await cards in interactor.cardListener(for: deck) {
            await MainActor.run {
                self.state.cards = cards
            }
        }
    }

    func presentSheet(for route: DeckSheetRoute) {
        state.sheetRoute = route
    }

    func presentCover(for route: DeckFullScreenRoute) {
        state.fullScreenRoute = route
    }
}
