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
            DeckView(deck: viewModel.bindingToDeck(deck))
        case .card(let card):
            Text("card \(card.id.uuidString)")
        }
    }
}
