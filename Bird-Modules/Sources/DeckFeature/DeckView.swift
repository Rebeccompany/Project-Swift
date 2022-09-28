//
//  DeckView.swift
//  
//
//  Created by Marcos Chevis on 30/08/22.
//

import Foundation
import SwiftUI
import Models
import HummingBird
import NewFlashcardFeature
import StudyFeature
import Storage
import Flock
import Utils

public struct DeckView: View {
    @StateObject private var viewModel: DeckViewModel
    @State private var shouldDisplayNewFlashcard: Bool = false
    @State private var shouldDisplayStudyView: Bool = false
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    @State private var deletedCard: Card?
    
    public init(viewModel: @autoclosure @escaping () -> DeckViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }
    
    public var body: some View {
        Group {
            if viewModel.cards.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .viewBackgroundColor(HBColor.primaryBackground)
        .onAppear(perform: viewModel.startup)
        .listStyle(.plain)
        .searchable(text: $viewModel.searchFieldContent)
        
        
        .alert(isPresented: $showingAlert) {
            switch activeAlert {
            case .error:
                return Alert(title: Text("Erro ao apagar flashcard."),
                             message: Text("Algo deu errado! Por favor, tente novamente."),
                             dismissButton: .default(Text("Fechar")))
            case .confirm:
                return Alert(title: Text("Deseja apagar este flashcard?"),
                             message: Text("Você perderá permanentemente o conteúdo deste flashcard."),
                             primaryButton: .destructive(Text("Apagar")) {
                                do {
                                    guard let deletedCard else { return }
                                    try viewModel.deleteFlashcard(card: deletedCard)
                                    self.deletedCard = nil
                                } catch {
                                    activeAlert = .error
                                    showingAlert = true
                                    selectedErrorMessage = .deleteCard
                                }
                             },
                             secondaryButton: .cancel(Text("Cancelar"))
                )
            }
        }
        .navigationTitle(viewModel.deck.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    viewModel.createFlashcard()
                    shouldDisplayNewFlashcard = true
                } label: {
                    Image(systemName: "plus")
                }
                .foregroundColor(HBColor.actionColor)
            }
        }
        .sheet(isPresented: $shouldDisplayNewFlashcard) {
            NewFlashcardView(deck: viewModel.deck, editingFlashcard: viewModel.editingFlashcard)
        }
        .fullScreenCover(isPresented: $shouldDisplayStudyView) {
            StudyView(
                deck: viewModel.deck  
            )
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            if viewModel.cards.isEmpty {
                VStack {
                    EmptyStateView(component: .flashcard)
                    Button {
                        viewModel.createFlashcard()
                        shouldDisplayNewFlashcard = true
                    } label: {
                        Text("Criar Flashcard")
                    }
                    .buttonStyle(LargeButtonStyle(isDisabled: false))
                    .padding()
                }
                
            }
        }
    }
    
    @ViewBuilder
    private var list: some View {
        List {
            if !viewModel.canStudy && !viewModel.cards.isEmpty {
                Text("Atividade diária concluída! Volte em breve para retornar com seus estudos!")
                    .bold()
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)
            }
            Button("Estudar Deck") {
                shouldDisplayStudyView = true
            }
            
            .disabled(!viewModel.canStudy)
            .buttonStyle(LargeButtonStyle(isDisabled: !viewModel.canStudy))
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding()
            
            ForEach(viewModel.cardsSearched) { card in
                FlashcardCell(card: card) {
                    viewModel.editFlashcard(card)
                    shouldDisplayNewFlashcard = true
                }
                .padding(.bottom, 8)
                .contextMenu {
                    Button {
                        viewModel.editFlashcard(card)
                        shouldDisplayNewFlashcard = true
                    } label: {
                        Label("Editar Flashcard",
                              systemImage: "pencil")
                    }
                    
                    Button(role: .destructive) {
                        deletedCard = card
                        activeAlert = .confirm
                        showingAlert = true
                    } label: {
                        Label("Deletar Flashcard",
                              systemImage: "trash.fill")
                    }
                    
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .scrollContentBackground(.hidden)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeckView(
                viewModel: DeckViewModel(
                    deck: Deck(
                        id: UUID(),
                        name: "Matemagica",
                        icon: "chevron.down",
                        color: .otherPink,
                        datesLogs: DateLogs(
                            lastAccess: Date(),
                            lastEdit: Date(),
                            createdAt: Date()),
                        collectionId: nil,
                        cardsIds: [
                            UUID(
                                uuidString: "1f222564-ff0d-4f2d-9598-1a0542899974"
                            )!,
                            UUID(
                                uuidString: "66605408-4cd4-4ded-b23d-91db9249a946"
                            )!,
                            UUID(
                                uuidString: "4f298230-4286-4a83-9f1c-53fd60533ed8"
                            )!,
                            UUID(
                                uuidString: "9b06af85-e4e8-442d-be7a-40450cfd310c"
                            )!,
                            UUID(
                                uuidString: "855eb618-602e-449d-83fc-5de6b8a36454"
                            )!,
                            UUID(
                                uuidString: "5285798a-4107-48b3-8994-e706699a3445"
                            )!,
                            UUID(
                                uuidString: "407e7694-316e-4903-9c94-b3ec0e9ab0e8"
                            )!,
                            UUID(
                                uuidString: "09ae6b07-b988-442f-a059-9ea76d5c9055"
                            )!,
                            UUID(
                                uuidString: "d3b5ba9a-7805-480e-ad47-43b842f0472f"
                            )!,
                            UUID(
                                uuidString: "d9d3d4ec-9854-4e73-864b-1e68355a6973"
                            )!,
                            UUID(
                                uuidString: "c24affd7-376d-4614-9ad6-8a83a0f60da5"
                            )!,
                            UUID(
                                uuidString: "d2c951fb-36f5-49dc-84f0-353a3b3a2875"
                            )!
                        ],
                        spacedRepetitionConfig: SpacedRepetitionConfig(
                            maxLearningCards: 20,
                            maxReviewingCards: 200
                        )
                    ),
                    deckRepository: DeckRepositoryMock()
                )
            )
        }
        .preferredColorScheme(.dark)
    }
}
