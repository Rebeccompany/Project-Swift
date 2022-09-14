//
//  TestView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 13/09/22.
//

import SwiftUI
import Flock
import Models

struct TesteView: View {
    @State var sidebarSelection: SidebarRoute? = .allDecks
    @ObservedObject private var store = RouterStore<StudyRoute>()
    
    var body: some View {
        NavigationSplitView {
            List(selection: $sidebarSelection) {
                NavigationLink(value: SidebarRoute.allDecks) {
                    Label("All Decks", systemImage: "chevron.down")
                }
                NavigationLink(value: SidebarRoute.decksFromCollection(id: UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!)) {
                    Label("Some Collection", systemImage: "flame")
                }
            }
        } detail: {
            NavigationStack(path: $store.path) {
                if let sidebarSelection {
                    switch sidebarSelection {
                    case .allDecks:
                        VStack {
                            Text("All decks")
                            NavigationLink(value: StudyRoute.deck(Deck(
                                id: UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!,
                                name: "New Deck",
                                icon: "chevron.down",
                                color: .darkBlue,
                                datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0), lastEdit: Date(timeIntervalSince1970: 0), createdAt: Date(timeIntervalSince1970: 0)),
                                collectionsIds: [],
                                cardsIds: []
                            ))) {
                                Text("deck")
                            }
                        }
                        .navigationDestination(for: StudyRoute.self) { _ in
                            Text("Navigated")
                        }
                    case .decksFromCollection(let id):
                        VStack {
                            Text("id: \(id.uuidString)")
                            NavigationLink(value: StudyRoute.deck(Deck(
                                id: UUID(uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974")!,
                                name: "New Deck",
                                icon: "chevron.down",
                                color: .darkBlue,
                                datesLogs: DateLogs(lastAccess: Date(timeIntervalSince1970: 0), lastEdit: Date(timeIntervalSince1970: 0), createdAt: Date(timeIntervalSince1970: 0)),
                                collectionsIds: [],
                                cardsIds: []
                            ))) {
                                Text("deck")
                            }
                        }
                        .navigationDestination(for: StudyRoute.self) { _ in
                            Text("Navigated")
                        }
                    }
                    
                } else {
                    Text("Empty State")
                }
            }
        }

    }
}

struct TesteView_Previews: PreviewProvider {
    static var previews: some View {
        TesteView()
    }
}

