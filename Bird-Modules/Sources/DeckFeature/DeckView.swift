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
    @StateObject private var viewModel: DeckViewModel = DeckViewModel()
    @State private var shouldDisplayNewFlashcard: Bool = false
    @State private var shouldDisplayStudyView: Bool = false
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    @State private var deletedCard: Card?
    @State private var editingFlashcard: Card?
    @Binding private var deck: Deck
    
    public init(deck: Binding<Deck>) {
        self._deck = deck
    }
    
    public var body: some View {
        Group {
            if viewModel.cards.isEmpty {
                emptyState
            } else {
                list
            }
        }
        .onAppear {
            viewModel.startup(deck)
        }
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
        .navigationTitle(deck.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    editingFlashcard = nil
                    shouldDisplayNewFlashcard = true
                } label: {
                    Image(systemName: "plus")
                }
                .foregroundColor(HBColor.actionColor)
            }
        }
        .sheet(isPresented: $shouldDisplayNewFlashcard) {
            NewFlashcardView(deck: deck, editingFlashcard: editingFlashcard)
        }
        .fullScreenCover(isPresented: $shouldDisplayStudyView) {
            StudyView(
                deck: deck
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
                        editingFlashcard = nil
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
            if !viewModel.checkIfCanStudy(deck) && !viewModel.cards.isEmpty {
                Text("Atividade diária concluída! Volte em breve para retornar com seus estudos!")
                    .bold()
                    .multilineTextAlignment(.center)
                    .listRowBackground(Color.clear)
            }
            Button("Estudar Deck") {
                shouldDisplayStudyView = true
            }
            
            .disabled(!viewModel.checkIfCanStudy(deck))
            .buttonStyle(LargeButtonStyle(isDisabled: !viewModel.checkIfCanStudy(deck)))
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding()
            
            ForEach(viewModel.cardsSearched) { card in
                FlashcardCell(card: card) {
                    editingFlashcard = card
                    shouldDisplayNewFlashcard = true
                }
                .padding(.bottom, 8)
                .contextMenu {
                    Button {
                        editingFlashcard = card
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
                deck: .constant(DeckRepositoryMock()
                    .decks[0])
            )
        }
        .preferredColorScheme(.dark)
    }
}
