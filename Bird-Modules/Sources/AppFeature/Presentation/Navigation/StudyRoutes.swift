//
//  StudyRoutes.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/22.
//

import SwiftUI
import Models
import DeckFeatureV2
import Storage
import Flock

struct StudyRoutes {
    @ViewBuilder
    static func destination(for route: StudyRoute, viewModel: ContentViewModel) -> some View {
        switch route {
        case .deck(let deck):
            #if os(iOS)
            DeckView(deckBinding: viewModel.bindingToDeck(deck))
            #elseif os(macOS)
            DeckViewMacOS(deck: viewModel.bindingToDeck(deck))
            //Text("deck: \(deck.name)")
            #endif
        case .card(let card):
            Text("card \(card.id.uuidString)")
        }
    }
}
