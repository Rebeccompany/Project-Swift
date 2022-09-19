//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/22.
//

import SwiftUI
import Models
import DeckFeature
import Flock

struct StudyRoutes {
    @ViewBuilder
    static func destination(for route: StudyRoute) -> some View {
        switch route {
        case .deck(let deck):
            Text("deck \(deck.name)")
        case .card(let card):
            Text("card \(card.id.uuidString)")
        }
    }
}
