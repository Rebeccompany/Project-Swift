//
//  SwiftUIView.swift
//  
//
//  Created by Marcos Chevis on 08/09/22.
//

import SwiftUI
import Storage
import Models
import HummingBird

public struct StudyView: View {
    @ObservedObject private var viewModel: StudyViewModel
    
    public init(viewModel: StudyViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            if !viewModel.displayedCards.isEmpty {
                
                VStack {
                    FlashcardDeckView(cards: $viewModel.displayedCards)
                        .zIndex(1)
                        .padding(.horizontal, 48)
                        .padding(.vertical)
                    HStack {
                        ForEach(UserGrade.allCases) { userGrade in
                            Spacer()
                            DifficultyButtonView(userGrade: userGrade, isDisabled: $viewModel.shouldButtonsBeDisabled) { userGrade in
                                withAnimation {
                                    viewModel.pressedButton(for: userGrade)
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
                
                
            } else {
                Text("EmptyState")
            }
        }
        .background(HBColor.primaryBackground)
        .navigationTitle(viewModel.deck.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startup()
        }
        
    }
}

struct StudyView_Previews: PreviewProvider {
    static var repo: DeckRepositoryMock { DeckRepositoryMock() }
    
    static var previews: some View {
        
        Group {
            NavigationView {
                StudyView(
                    viewModel: StudyViewModel(
                        deckRepository: repo,
                        sessionCacher: SessionCacher(
                            storage: LocalStorageMock()
                        ),
                        deck: repo.decks.first!,
                        dateHandler: DateHandler()
                    )
                )
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            
            NavigationView {
                StudyView(
                    viewModel: StudyViewModel(
                        deckRepository: repo,
                        sessionCacher: SessionCacher(
                            storage: LocalStorageMock()
                        ),
                        deck: repo.decks.first!,
                        dateHandler: DateHandler()
                    )
                )
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
            
            NavigationView {
                StudyView(
                    viewModel: StudyViewModel(
                        deckRepository: repo,
                        sessionCacher: SessionCacher(
                            storage: LocalStorageMock()
                        ),
                        deck: repo.decks.first!,
                        dateHandler: DateHandler()
                    )
                )
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}
