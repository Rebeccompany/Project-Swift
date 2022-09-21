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
import Utils

public struct StudyView: View {
    @ObservedObject private var viewModel: StudyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingErrorAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    
    public init(viewModel: StudyViewModel) {
        self.viewModel = viewModel
    }
    
    private func toString(_ attributed: AttributedString) -> String {
        NSAttributedString(attributed).string
    }
    
    #warning("Bug de Index out Range")
    private func generateAttributedLabel() -> String {
        if !viewModel.cards.isEmpty {
            if viewModel.displayedCards.count > 1 && !viewModel.displayedCards[1].isFlipped {
                return "Frente: " + toString(viewModel.displayedCards[0].card.front)
            } else {
                return "Verso: " + toString(viewModel.displayedCards[0].card.back)
            }
        }
        return ""
    }
    //swiftlint:disable trailing_closure
    public var body: some View {
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
                                        try viewModel.pressedButton(for: userGrade)
                                    } catch {
                                        selectedErrorMessage = .gradeCard
                                        showingErrorAlert = true
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .accessibilityElement(children: .contain)
                    .accessibilityHint("Escolha nível de dificuldade")
                    .accessibilityLabel("Quatro Botões.")
                }
                
                
            } else {
                Text("EmptyState")
            }
        }
        .background(HBColor.primaryBackground)
        .navigationTitle(viewModel.deck.name)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .destructive) {
                    do {
                        try viewModel.saveChanges()
                        dismiss()
                    } catch {
                        selectedErrorMessage = .saveStudy
                        showingErrorAlert = true
                    }
                } label: {
                    Text("Sair")
                }
                .foregroundColor(.red)
                
                
            }
        })
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startup()
        }
        
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text(selectedErrorMessage.texts.title),
                  message: Text(selectedErrorMessage.texts.message),
                  dismissButton: .default(Text("Fechar")))
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
            .previewDisplayName("iPhone 12")
            
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
            .previewDisplayName("iPhone 13 Pro Max")
            
            
            NavigationStack {
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
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
            .previewDisplayName("iPad Pro (12.9-inch)")
            
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
            .previewDisplayName("iPhone SE (3rd generation)")
        }
    }
}
