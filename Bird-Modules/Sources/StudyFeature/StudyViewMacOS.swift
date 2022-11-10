//
//  StudyViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 08/11/22.
//
//

import SwiftUI
import Storage
import Models
import HummingBird
import Utils
import FlashcardsOnboardingFeature

#if os(macOS)
public struct StudyViewMacOS: View {
    @State private var flashcardsOnboarding: Bool = false
    @StateObject private var viewModel: StudyViewModel = StudyViewModel()
    @State private var showingErrorAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var shouldDisplaySessionProgress: Bool = false
    
    var data: StudyWindowData
    
    public init(data: StudyWindowData) {
        self.data = data
    }
    
    private func generateAttributedLabel() -> String {
        if !viewModel.cards.isEmpty {
            let card = viewModel.displayedCards[0].card
            guard let isFlipped = viewModel.displayedCards.last?.isFlipped else {
                return ""
            }
            
            if !isFlipped {
                return NSLocalizedString("frente", bundle: .module, comment: "") + ": " + card.front.string
            } else {
                return NSLocalizedString("verso", bundle: .module, comment: "") + ": " + card.back.string
            }
        }
        return ""
    }
    //swiftlint:disable trailing_closure
    public var body: some View {
        NavigationStack {
            ZStack {
                if !viewModel.displayedCards.isEmpty {
                    
                    VStack {
                        FlashcardDeckView(cards: $viewModel.displayedCards)
                            .zIndex(1)
                            .padding(.vertical)
                            .accessibilityElement(children: .ignore)
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel(generateAttributedLabel())
                            .accessibilityHidden(viewModel.cards.isEmpty)
                        
                        Spacer()
                        
                        HStack {
                            ForEach(UserGrade.allCases) { userGrade in
                                Spacer()
                                DifficultyButtonView(userGrade: userGrade, isDisabled: $viewModel.shouldButtonsBeDisabled, isVOOn: $viewModel.isVOOn) { userGrade in
                                    withAnimation {
                                        do {
                                            try viewModel.pressedButton(for: userGrade, deck: data.deck, mode: data.mode)
                                        } catch {
                                            selectedErrorMessage = .gradeCard
                                            showingErrorAlert = true
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .accessibilityElement(children: .contain)
                        .accessibilityHint(NSLocalizedString("escolha_nivel", bundle: .module, comment: ""))
                        .accessibilityLabel(NSLocalizedString("quatro_botoes", bundle: .module, comment: ""))
                    }
                    .toolbar {
                        ToolbarItem {
                            Button {
                                shouldDisplaySessionProgress = true
                            } label: {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(HBColor.actionColor)
                            }
                            .popover(isPresented: $shouldDisplaySessionProgress) {
                                StudyProgressView(numOfTotalSeen: viewModel.getSessionTotalSeenCards(), numOfTotalCards: viewModel.getSessionTotalCards(), numOfReviewingSeen: viewModel.getSessionReviewingSeenCards(mode: data.mode), numOfReviewingCards: viewModel.getSessionReviewingCards(mode: data.mode), numOfLearningSeen: viewModel.getSessionLearningSeenCards(mode: data.mode), numOfLearningCards: viewModel.getSessionLearningCards(mode: data.mode), studyMode: data.mode)
                                    .frame(minWidth: 300, minHeight: 600)
                            }
                        }
                    }
    
                } else {
                    EndOfStudyViewMacOS(mode: data.mode)
                }
            }
            .viewBackgroundColor(HBColor.primaryBackground)
            .navigationTitle(data.deck.name)
            .onDisappear {
                try? viewModel.saveChanges(deck: data.deck, mode: data.mode)
            }
            .toolbar(content: {

                ToolbarItem {
                    Button {
                        flashcardsOnboarding = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(HBColor.actionColor)
                            .accessibility(addTraits: .isButton)
                    }
                    .sheet(isPresented: $flashcardsOnboarding) {
                        FlashcardsOnboardingView()
                            .frame(minWidth: 300, maxWidth: 500, minHeight: 500)
                    }
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive) {
                        do {
                            if data.mode == .spaced {
                                try viewModel.saveChanges(deck: data.deck, mode: data.mode)
                            }
                        } catch {
                            selectedErrorMessage = .saveStudy
                            showingErrorAlert = true
                        }
                    } label: {
                        Text("sair", bundle: .module)
                    }
                    .foregroundColor(.red)
                }
                
            })
            .onAppear {
                viewModel.startup(deck: data.deck, mode: data.mode)
            }
            
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text(selectedErrorMessage.texts.title),
                      message: Text(selectedErrorMessage.texts.message),
                      dismissButton: .default(Text("fechar", bundle: .module)))
            }
        }
        
    }
}

struct StudyViewMacOS_Previews: PreviewProvider {
    static var repo: DeckRepositoryMock { DeckRepositoryMock() }
    
    static var previews: some View {
        StudyViewMacOS(data: StudyWindowData(deck: repo.decks.first { $0.id == repo.deckWithCardsId }!, mode: .spaced))
    }
}
#endif
