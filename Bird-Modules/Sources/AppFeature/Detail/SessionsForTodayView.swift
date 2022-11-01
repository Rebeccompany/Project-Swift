//
//  SessionsForTodayView.swift
//  
//
//  Created by Caroline Taus on 25/10/22.
//

import SwiftUI
import Models
import StudyFeature

struct SessionsForTodayView: View {
    
    @EnvironmentObject private var viewModel: ContentViewModel
    @State private var shouldPresentStudyView: Bool = false
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(viewModel.todayDecks) { deck in
                    
                    Button {
                        shouldPresentStudyView = true
                    } label: {
                        DeckForTodayCell(deck: deck)
                    }

                    .fullScreenCover(isPresented: $shouldPresentStudyView) {
                            StudyView(
                                deck: deck,
                                mode: .spaced
                            )
                        }
                }
            }
        }
        .padding(.leading)
    }
    
}

struct SessionsForTodayView_Previews: PreviewProvider {
    static var previews: some View {
        SessionsForTodayView()
    }
}
