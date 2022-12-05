//
//  DeckViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 28/10/22.
//

import Foundation
import SwiftUI
import Models
import HummingBird
import NewFlashcardFeature
import ImportingFeature
import StudyFeature
import Puffins
import Authentication
import Storage
import Flock
import Utils

#if os(macOS)
public struct DeckViewMacOS: View {
    @StateObject private var viewModel: DeckViewModel = DeckViewModel()
    @EnvironmentObject private var authModel: AuthenticationModel
    @State private var shouldDisplayPublishConfirmation: Bool = false
    @State private var shouldDisplayStudyView: Bool = false
    @State private var studyMode: StudyMode = .spaced
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    @State private var confirmationDialogData: PublishConfirmationDialogData?
    @State private var deletedCard: Card?
    @Binding private var deck: Deck
    
    @Environment(\.openWindow) private var openWindow
    
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
        .onDisappear {
            viewModel.tearDown()
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchFieldContent)
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
            case .close:
                return Alert(title: Text("does not apply"))
            }
        }
        .navigationTitle(deck.name)
        .toolbar {
            ToolbarItemGroup {
                Menu {
                    if let user = authModel.user {
                        loggedInShareMenu(user)
                    } else {
                        loggedOffShareMenu()
                    }
                } label: {
                    Label(
                        NSLocalizedString("publicar", bundle: .module, comment: ""),
                        systemImage: "globe.americas"
                    )
                }
                .disabled(deck.cardCount == 0)
                
                Menu {
                    Button {
                        let model = NewFlashcardWindowData(deckId: deck.id)
                        openWindow(value: model)
                    } label: {
                        Label(
                            NSLocalizedString("add", bundle: .module, comment: ""),
                            systemImage: "plus"
                        )
                    }

                    Button {
                        let model = ImportWindowData(deck: deck)
                        openWindow(value: model)
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
            }
        }
        .confirmationDialog(
            "Are you sure?",
            isPresented: $shouldDisplayPublishConfirmation,
            presenting: confirmationDialogData
            ) { data in
                confirmationDialogAction(data)
            } message: { data in
                confirmationDialogMessage(data)
        }
    }
    
    @ViewBuilder
    private func confirmationDialogAction(_ data: PublishConfirmationDialogData) -> some View {
        switch data {
        case .delete:
            Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                viewModel.deletePublicDeck(deck)
            }
        case .update(let user):
            Button(NSLocalizedString("atualizar", bundle: .module, comment: "")) {
                viewModel.updatePublicDeck(deck, user: user)
            }
        case .publish(let user):
            Button(NSLocalizedString("publicar", bundle: .module, comment: "")) {
                viewModel.publishDeck(deck, user: user)
            }
        }
    }
    
    @ViewBuilder
    private func confirmationDialogMessage(_ data: PublishConfirmationDialogData) -> some View {
        switch data {
        case .delete:
            Text("aviso_deletar", bundle: .module)
        case .update(_):
            Text("aviso_atualizar", bundle: .module)
        case .publish(_):
            Text("aviso_publicar", bundle: .module)
        }
    }
    
    @ViewBuilder
    private var emptyState: some View {
        VStack {
            EmptyStateView(component: .flashcard)
            Button {
                let model = NewFlashcardWindowData(deckId: deck.id)
                openWindow(value: model)
            } label: {
                Text("criar_flashcard", bundle: .module)
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
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
                    .padding(.vertical)
                if !viewModel.checkIfCanStudy(deck) && !viewModel.cards.isEmpty {
                    Text(NSLocalizedString("no_study_allowed", bundle: .module, comment: ""))
                        .padding(.leading)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .listRowBackground(Color.clear)
                }
                
                HStack(alignment: .center) {
                    Spacer()
                    Button(NSLocalizedString("intenso", bundle: .module, comment: "")) {
                        studyMode = .cramming
                        shouldDisplayStudyView = true
                        
                        let model = StudyWindowData(deck: deck, mode: studyMode)
                        openWindow(value: model)
                    }
                    .buttonStyle(LargeButtonStyle(isDisabled: false, isFilled: false))
                    .listRowInsets(.zero)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: 350)
                    .padding(.horizontal, 5)
                    
                    Button {
                        studyMode = .spaced
                        shouldDisplayStudyView = true
                        
                        let model = StudyWindowData(deck: deck, mode: studyMode)
                        openWindow(value: model)
                    } label: {
                        Text("Spixii")
                            .foregroundColor(HBColor.collectionTextColor)
                    }
                    .disabled(!viewModel.checkIfCanStudy(deck))
                    .buttonStyle(LargeButtonStyle(isDisabled: !viewModel.checkIfCanStudy(deck), isFilled: true))
                    .listRowInsets(.zero)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .frame(maxWidth: 350)
                    .padding(.horizontal, 5)
                    Spacer()
                }
                
                Text("Flashcards")
                    .font(.title3)
                    .bold()
                    .padding(.leading)
                    .padding(.vertical)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 12, alignment: .top)], spacing: 12) {
                    ForEach(viewModel.cardsSearched) { card in
                        FlashcardCell(card: card) {
                            let model = NewFlashcardWindowData(deckId: deck.id, editingFlashcardId: card.id)
                            openWindow(value: model)
                        }
                        .contextMenu {
                            Button {
                                let model = NewFlashcardWindowData(deckId: deck.id, editingFlashcardId: card.id)
                                openWindow(value: model)
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
                    }
                    .listRowSeparator(.hidden)
                }
                .padding(.horizontal)
            }.scrollContentBackground(.hidden)
                
                
        }
    }
    
    @ViewBuilder
    private func loggedInShareMenu(_ user: User) -> some View {
        Section("Deck") {
            Button {
                confirmationDialogData = .publish(user: user)
                shouldDisplayPublishConfirmation = true
            } label: {
                Label {
                    Text(NSLocalizedString("publicar", bundle: .module, comment: ""))
                } icon: {
                    Image(systemName: "arrow.up")
                }

            }
            .disabled(viewModel.isPublishButtonDisabled(for: deck))
            
            Button {
                confirmationDialogData = .update(user: user)
                shouldDisplayPublishConfirmation = true
            } label: {
                Label {
                    Text(NSLocalizedString("atualizar", bundle: .module, comment: ""))
                } icon: {
                    Image(systemName: "square.and.pencil")
                }
            }
            .disabled(viewModel.isUpdateButtonDisabled(for: deck, user: user))
            
            if let id = deck.storeId {
                ShareLink(
                    item: DeepLinkURL.url(path: "store/\(id)")) {
                        Label {
                            Text("compartilhar", bundle: .module)
                        } icon: {
                            Image(systemName: "square.and.arrow.up")
                        }.bold()
                        
                        .frame(minWidth: 140)

                }
                .buttonStyle(.borderedProminent)
                .tint(HBColor.actionColor.opacity(0.15))
                .foregroundColor(HBColor.actionColor)
                .padding(.bottom)
                .disabled(viewModel.isShareButtonDisabled(for: deck))
            }
            
            Button(role: .destructive) {
                confirmationDialogData = .delete
                shouldDisplayPublishConfirmation = true
            } label: {
                Label {
                    Text(NSLocalizedString("deletar", bundle: .module, comment: ""))
                } icon: {
                    Image(systemName: "trash")
                }

            }
            .disabled(viewModel.isDeleteButtonDisabled(for: deck, user: user))
        }
        Section(NSLocalizedString("usuario", bundle: .module, comment: "")) {
            Button(NSLocalizedString("signout", bundle: .module, comment: "")) {
                authModel.signOut()
            }
            
            Button(NSLocalizedString("deletar_conta", bundle: .module, comment: ""), role: .destructive) {
                authModel.deleteAccount()
            }
        }
    }
    
    @ViewBuilder
    private func loggedOffShareMenu() -> some View {
        Text("aviso_login", bundle: .module)
    }
}

struct DeckViewMacOS_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DeckViewMacOS(
                deck: .constant(Deck(id: UUID(), name: "Palavras em Inglês", icon: "flame", color: CollectionColor.darkPurple, datesLogs: DateLogs(), collectionId: nil, cardsIds: [], spacedRepetitionConfig: .init(), session: Session(cardIds: [UUID(), UUID()], date: Date(), deckId: UUID(), id: UUID()), category: .others, storeId: nil, description: "", ownerId: nil)))
        }
        .preferredColorScheme(.dark)
    }
}
#endif
