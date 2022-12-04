//
//  StudyViewiOS.swift
//  
//
//  Created by Marcos Chevis on 08/09/22.
//

import SwiftUI
import Storage
import Models
import HummingBird
import Utils
import FlashcardsOnboardingFeature

#if os(iOS)
public struct StudyViewiOS: View {
    @State private var flashcardsOnboarding: Bool = false
    @StateObject private var viewModel: StudyViewModel = StudyViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingErrorAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var shouldDisplaySessionProgress: Bool = false
    
    var deck: Deck
    let mode: StudyMode
    
    public init(deck: Deck, mode: StudyMode) {
        self.deck = deck
        self.mode = mode
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
                        
                        HStack(alignment: .top) {
                            ForEach(UserGrade.allCases) { userGrade in
                                Spacer()
                                DifficultyButtonView(userGrade: userGrade, isDisabled: $viewModel.shouldButtonsBeDisabled, isVOOn: $viewModel.isVOOn) { userGrade in
                                    withAnimation {
                                        do {
                                            try viewModel.pressedButton(for: userGrade, deck: deck, mode: mode)
                                        } catch {
                                            selectedErrorMessage = .gradeCard
                                            showingErrorAlert = true
                                        }
                                    }
                                }
                                .hoverEffect(.lift)
                                Spacer()
                            }
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
                                StudyProgressView(numOfTotalSeen: viewModel.getSessionTotalSeenCards(), numOfTotalCards: viewModel.getSessionTotalCards(), numOfReviewingSeen: viewModel.getSessionReviewingSeenCards(mode: mode), numOfReviewingCards: viewModel.getSessionReviewingCards(mode: mode), numOfLearningSeen: viewModel.getSessionLearningSeenCards(mode: mode), numOfLearningCards: viewModel.getSessionLearningCards(mode: mode), studyMode: mode)
                                .frame(minWidth: 300, minHeight: 600)
                            }
                        }
                    }
    
                } else {
                    EndOfStudyViewiOS(mode: mode) {
                        do {
                            try viewModel.saveChanges(deck: deck, mode: mode)
                        } catch {
                            selectedErrorMessage = .saveStudy
                            showingErrorAlert = true
                        }
                    }
                }
            }
            .viewBackgroundColor(HBColor.primaryBackground)
            .navigationTitle(deck.name)
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
                    }
                }

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
                    }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive) {
                        do {
                            if mode == .spaced {
                                try viewModel.saveChanges(deck: deck, mode: mode)
                            } else {
                                dismiss()
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
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.startup(deck: deck, mode: mode)
            }
            
            .alert(isPresented: $showingErrorAlert) {
                Alert(title: Text(selectedErrorMessage.texts.title),
                      message: Text(selectedErrorMessage.texts.message),
                      dismissButton: .default(Text("fechar", bundle: .module)))
            }
        }
        .onChange(of: viewModel.shouldDismiss) { newValue in
            if newValue {
                dismiss()
            }
        }
        
    }
    
}

struct StudyViewiOS_Previews: PreviewProvider {
    static var repo: DeckRepositoryMock { DeckRepositoryMock() }

    static var previews: some View {
        StudyViewiOS(deck: Deck(id: UUID(), name: "Deck Nome", icon: IconNames.atom.rawValue, color: CollectionColor.red, collectionId: UUID(), cardsIds: [], category: .humanities, storeId: nil, description: "", ownerId: nil), mode: .spaced)
    }
}
#endif
