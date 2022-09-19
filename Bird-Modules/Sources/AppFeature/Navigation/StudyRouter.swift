//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/22.
//

import SwiftUI
import Models
import Flock

struct StudyRouter: View {
    @State private var path: NavigationPath = .init()
    
    var sidebarSelection: SidebarRoute
    
    var body: some View {
        Router(path: $path) {
            DummyDetailView(sidebarSelection: sidebarSelection)
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

struct DummyDetailView: View {
    
    @EnvironmentObject private var store: RouterStore<StudyRoute>
    var sidebarSelection: SidebarRoute
    
    var body: some View {
        switch sidebarSelection {
        case .allDecks:
            allDecks
        case .decksFromCollection(_):
            decksFromCollection
        }
    }
    
    @ViewBuilder
    var allDecks: some View {
        List {
            Text("All Decks")
            NavigationLink(value: StudyRoute.deck(
                Deck(id: UUID(),
                     name: "Programação Swift",
                     icon: IconNames.pencil.rawValue,
                     color: .red,
                     datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                         lastEdit: Date(timeIntervalSince1970: 0),
                                         createdAt: Date(timeIntervalSince1970: 0)),
                     collectionsIds: [],
                     cardsIds: [],
                     spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                   maxReviewingCards: 200))
            )) {
                Text("Deck Nav link")
            }
            
            Button {
                store.push(route: .deck(
                    Deck(id: UUID(),
                         name: "Programação Swift",
                         icon: IconNames.pencil.rawValue,
                         color: .red,
                         datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                             lastEdit: Date(timeIntervalSince1970: 0),
                                             createdAt: Date(timeIntervalSince1970: 0)),
                         collectionsIds: [],
                         cardsIds: [],
                         spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                       maxReviewingCards: 200))
                ))
            } label: {
                Text("Deck Button")
            }
        }
    }
    
    @ViewBuilder
    var decksFromCollection: some View {
        LazyVStack {
            
            Text("Deck From Collection")
            NavigationLink(value: StudyRoute.deck(
                Deck(id: UUID(),
                     name: "Programação Swift",
                     icon: IconNames.pencil.rawValue,
                     color: .red,
                     datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                         lastEdit: Date(timeIntervalSince1970: 0),
                                         createdAt: Date(timeIntervalSince1970: 0)),
                     collectionsIds: [],
                     cardsIds: [],
                     spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                   maxReviewingCards: 200))
            )) {
                Text("Deck Nav link")
            }
            
            Button {
                store.push(route: .deck(
                    Deck(id: UUID(),
                         name: "Programação Swift",
                         icon: IconNames.pencil.rawValue,
                         color: .red,
                         datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                                             lastEdit: Date(timeIntervalSince1970: 0),
                                             createdAt: Date(timeIntervalSince1970: 0)),
                         collectionsIds: [],
                         cardsIds: [],
                         spacedRepetitionConfig: .init(maxLearningCards: 20,
                                                       maxReviewingCards: 200))
                ))
            } label: {
                Text("Deck Button")
            }
        }
    }
}
