//
//  SessionsForTodayView.swift
//  
//
//  Created by Caroline Taus on 25/10/22.
//

import SwiftUI
import Models
import StudyFeature
import HummingBird

struct SessionsForTodayView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    
    @State private var selectedDeck: Deck?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.todayDecks) { deck in
                    if viewModel.detailType == .grid {
                        Button {
                            selectedDeck = deck
                        } label: {
                            DeckForTodayCell(deck: deck)
                        }
                    } else {
                        Button {
                            selectedDeck = deck
                        } label: {
                            Label(deck.name, systemImage: deck.icon)
                        }
                        .buttonStyle(.bordered)
                        .tint(HBColor.color(for: deck.color))
                        .buttonBorderShape(.capsule)
                    }
                }
            }
            .padding(.leading)
        }
        .fullScreenCover(item: $selectedDeck) { deck in
            StudyView(deck: deck, mode: .spaced)
        }
    }
    
}

struct SessionsForTodayView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsForTodayView()
    }
}
