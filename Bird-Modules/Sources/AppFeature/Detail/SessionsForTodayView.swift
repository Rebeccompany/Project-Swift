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
    
    @Environment(\.openWindow) private var openWindow
    
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
                        #if os(macOS)
                        .buttonStyle(.plain)
                        #endif
                    } else {
                        Button {
                            selectedDeck = deck
                        } label: {
                            Label(deck.name, systemImage: deck.icon)
                        }
                        .buttonStyle(.bordered)
                        #if os(iOS)
                        .buttonBorderShape(.capsule)
                        #endif
                        .tint(HBColor.color(for: deck.color))
                    }
                }
            }
            .padding(.leading)
        }
        #if os(iOS)
        .fullScreenCover(item: $selectedDeck) { deck in
            StudyViewiOS(deck: deck, mode: .spaced)
        }
        #elseif os(macOS)
        .onChange(of: selectedDeck) { deck in
            guard let deck else {
                return
            }
            
            openWindow(value: StudyWindowData(deck: deck, mode: .spaced))
        }
        #endif
    }
    
}

struct SessionsForTodayView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsForTodayView()
    }
}
