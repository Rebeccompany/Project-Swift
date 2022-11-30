//
//  DeckView.swift
//  
//
//  Created by Marcos Chevis on 30/08/22.
//

import Flock
import Utils
import Models
import Storage
import SwiftUI
import Habitat
import Puffins
import Foundation
import HummingBird
import StudyFeature
import Authentication
import ImportingFeature
import NewFlashcardFeature

enum PublishConfirmationDialogData {
    case delete
    case update(user: UserDTO)
    case publish(user: UserDTO)
}

public struct DeckView: View {
    @StateObject private var viewModel: DeckViewModel = DeckViewModel()
    @EnvironmentObject private var authModel: AuthenticationModel
    @State private var shouldDisplayNewFlashcard: Bool = false
    @State private var shouldDisplayImport: Bool = false
    @State private var shouldDisplayStudyView: Bool = false
    @State private var shouldDisplayPublishConfirmation: Bool = false
    @State private var studyMode: StudyMode = .spaced
    @State private var showingAlert: Bool = false
    @State private var selectedErrorMessage: AlertText = .deleteCard
    @State private var activeAlert: ActiveAlert = .error
    @State private var deletedCard: Card?
    @State private var editingFlashcard: Card?
    @State private var confirmationDialogData: PublishConfirmationDialogData?
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
        .overlay(content: loadingOverlay)
        .onAppear {
            viewModel.startup(deck)
        }
        .onChange(of: viewModel.loadingPhase) { newValue in
            guard newValue != nil else { return }
            
            if newValue == .showFailure || newValue == .showSuccess {
                withAnimation(.linear(duration: 0.2).delay(0.5)) {
                    viewModel.loadingPhase = nil
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchFieldContent, placement: .navigationBarDrawer(displayMode: .always))
        .confirmationDialog("Are you sure you want to delete the flashcard?", isPresented: $showingAlert) {
            Button(NSLocalizedString("deletar", bundle: .module, comment: ""), role: .destructive) {
                if deletedCard != nil {
                    guard let deletedCard else { return }
                    try? viewModel.deleteFlashcard(card: deletedCard)
                    self.deletedCard = nil
                } else {
                    activeAlert = .error
                    showingAlert = true
                    selectedErrorMessage = .deleteCard
                }
            }
        } message: {
            switch activeAlert {
            case .error:
                Text(NSLocalizedString("alert_delete_flashcard_error_text", bundle: .module, comment: ""))
            case .confirm:
                Text(NSLocalizedString("alert_delete_flashcard_text", bundle: .module, comment: ""))
            }
        }
        .navigationTitle(deck.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
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
                    .padding(.bottom, 8)
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
                .padding(.horizontal)

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
                    .padding(.horizontal, -2)
                    .listRowSeparator(.hidden)
                }
                .padding(.horizontal)
            }.scrollContentBackground(.hidden)
        }
    }
    
    @ViewBuilder
    private func loadingOverlay() -> some View {
        if viewModel.loadingPhase == .loading {
            ZStack {
                Color.black.opacity(0.5)
                ProgressView()
            }
        } else if viewModel.loadingPhase == .showSuccess {
            ZStack {
                Color.black.opacity(0.5)
                Image(systemName: "checkmark")
                    .foregroundColor(HBColor.collectionGreen)
                    .font(.title.bold())
                    .padding()
                    .background {
                        Circle()
                            .fill(HBColor.secondaryBackground)
                    }
                    
            }
        } else if viewModel.loadingPhase == .showFailure {
            ZStack {
                Color.black.opacity(0.5)
                Image(systemName: "xmark")
                    .foregroundColor(HBColor.collectionRed)
                    .font(.title.bold())
                    .padding()
                    .background {
                        Circle()
                            .fill(HBColor.secondaryBackground)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func loggedInShareMenu(_ user: UserDTO) -> some View {
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

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                DeckView(
                    deck: .constant(Deck(id: UUID(), name: "Deck Nome", icon: IconNames.atom.rawValue, color: CollectionColor.red, collectionId: UUID(), cardsIds: [], category: .humanities, storeId: nil, description: "", ownerId: nil))
                )
                .environmentObject(AuthenticationModel())
            }
        }
    }
}
