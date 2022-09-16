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

struct StudyRouter: View {
    @State private var path: NavigationPath = .init()
    var decks: [Deck]
    
    var body: some View {
        Router(path: $path) {
            DetailView(decks: decks)
        } destination: { (route: StudyRoute) in
            destination(for: route)
        }

    }
    
    @ViewBuilder
    func destination(for route: StudyRoute) -> some View {
        switch route {
        case .deck(let deck):
            Text("deck \(deck.name)")
        case .card(let card):
            Text("card \(card.id.uuidString)")
        }
    }
}
