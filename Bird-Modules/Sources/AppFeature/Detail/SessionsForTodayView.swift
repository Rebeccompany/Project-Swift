//
//  SessionsForTodayView.swift
//  
//
//  Created by Caroline Taus on 25/10/22.
//

import SwiftUI
import Models

struct SessionsForTodayView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(viewModel.todayDecks) { deck in
                    DeckForTodayCell(deck: deck)
                }
            }
            .padding(.leading)
        }
    }
}

struct SessionsForTodayView_Previews: PreviewProvider {
    static var previews: some View {
        
        SessionsForTodayView()
    }
}
