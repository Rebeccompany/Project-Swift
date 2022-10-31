//
//  StudyRoutes.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/22.
//

import SwiftUI
import Models
import DeckFeature
import Storage
import Flock

struct StudyRoutes {
    @ViewBuilder
    static func destination(for route: StudyRoute, viewModel: ContentViewModel) -> some View {
        switch route {
        case .deck(let deck):
            #if os(iOS)
            DeckViewiOS(deck: viewModel.bindingToDeck(deck))
            #elseif os(macOS)
            DeckViewMacOS(deck: viewModel.bindingToDeck(deck))
            #endif
        case .card(let card):
            Text("card \(card.id.uuidString)")
        }
    }
}
