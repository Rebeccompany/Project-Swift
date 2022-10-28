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
import ImportingFeature
import StudyFeature
import Storage
import Flock
import Utils

public struct DeckView: View {
    @StateObject private var viewModel: DeckViewModel = DeckViewModel()
    @State private var shouldDisplayNewFlashcard: Bool = false
    @State private var shouldDisplayImport: Bool = false
    @State private var shouldDisplayStudyView: Bool = false
    @State private var studyMode: StudyMode = .spaced
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
                grid
            }
        }
        .onAppear {
            viewModel.startup(deck)
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchFieldContent, placement: .navigationBarDrawer(displayMode: .always))
        .alert(isPresented: $showingAlert) {
            switch activeAlert {
            case .error:
                return Alert(title: Text(NSLocalizedString("alert_delete_flashcard_error", bundle: .module, comment: "")),
                             message: Text(NSLocalizedString("alert_delete_flashcard_error_text", bundle: .module, comment: "")),
                             dismissButton: .default(Text(NSLocalizedString("fechar", bundle: .module, comment: ""))))
            case .confirm:
                return Alert(title: Text(NSLocalizedString("alert_delete_flashcard", bundle: .module, comment: "")),
                             message: Text(NSLocalizedString("alert_delete_flashcard_text", bundle: .module, comment: "")),
                             primaryButton: .destructive(Text(NSLocalizedString("deletar", bundle: .module, comment: ""))) {
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
                secondaryButton: .cancel(Text(NSLocalizedString("cancelar", bundle: .module, comment: "")))
                )
            }
        }
        .navigationTitle(deck.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        editingFlashcard = nil
                        shouldDisplayNewFlashcard = true
                    } label: {
                        Label(
                            NSLocalizedString("add", bundle: .module, comment: ""),
                            systemImage: "plus"
                        )
                    }
                    
                    Button {
                        shouldDisplayImport = true
                    } label: {
                        Label(
                            NSLocalizedString("import", bundle: .module, comment: ""),
                            systemImage: "arrow.down"
                        )
                    }
                    
                } label: {
                    Label(
                        NSLocalizedString("add", bundle: .module, comment: ""),
                        systemImage: "plus"
                    )
                }
                .foregroundColor(HBColor.actionColor)
                .fullScreenCover(isPresented: $shouldDisplayNewFlashcard) {
                    NewFlashcardView(deck: deck, editingFlashcard: editingFlashcard)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldDisplayStudyView) {
            StudyView(
                deck: deck,
                mode: studyMode
            )
        }
        .sheet(isPresented: $shouldDisplayImport) {
            ImportView(deck: deck, isPresenting: $shouldDisplayImport)
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
                        Text("criar_flashcard", bundle: .module)
                    }
                    .buttonStyle(LargeButtonStyle(isDisabled: false))
                    .padding()
                }
                
            }
        }
    }
    
    @ViewBuilder
    private var grid: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text("modos_de_estudo", bundle: .module)
                    .font(.title3)
                    .bold()
                    .padding(.leading)
                    .padding(.bottom)
                if !viewModel.checkIfCanStudy(deck) && !viewModel.cards.isEmpty {
                    Text(NSLocalizedString("no_study_allowed", bundle: .module, comment: ""))
                        .padding(.leading)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .listRowBackground(Color.clear)
                }
                
                Button("Spixii") {
                    studyMode = .spaced
                    shouldDisplayStudyView = true
                }
                .hoverEffect(.automatic)
                .disabled(!viewModel.checkIfCanStudy(deck))
                .buttonStyle(LargeButtonStyle(isDisabled: !viewModel.checkIfCanStudy(deck), isFilled: true))
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding()

                Button(NSLocalizedString("intenso", bundle: .module, comment: "")) {
                    studyMode = .cramming
                    shouldDisplayStudyView = true
                }
                .hoverEffect(.automatic)
                .buttonStyle(LargeButtonStyle(isDisabled: false, isFilled: false))
                .listRowInsets(.zero)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding(.horizontal)
                .padding(.bottom)
                
                Text("Flashcards")
                    .font(.title3)
                    .bold()
                    .padding(.leading)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 12, alignment: .top)], spacing: 12) {
                    ForEach(viewModel.cardsSearched) { card in
                        FlashcardCell(card: card) {
                            editingFlashcard = card
                            shouldDisplayNewFlashcard = true
                        }
                        .contextMenu {
                            Button {
                                editingFlashcard = card
                                shouldDisplayNewFlashcard = true
                            } label: {
                                Label(NSLocalizedString("editar_flashcard", bundle: .module, comment: ""),
                                      systemImage: "pencil")
                            }
                            
                            Button(role: .destructive) {
                                deletedCard = card
                                activeAlert = .confirm
                                showingAlert = true
                            } label: {
                                Label(NSLocalizedString("deletar_flashcard", bundle: .module, comment: ""),
                                      systemImage: "trash.fill")
                            }
                        }
                        .frame(height: 230)
                        .padding(2)
                        .hoverEffect()
                    }
                    .listRowSeparator(.hidden)
                }
                .padding(.horizontal)
            }.scrollContentBackground(.hidden)
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeckView(
                deck: .constant(DeckRepositoryMock()
                    .decks[1])
            )
        }
        .preferredColorScheme(.dark)
    }
}
