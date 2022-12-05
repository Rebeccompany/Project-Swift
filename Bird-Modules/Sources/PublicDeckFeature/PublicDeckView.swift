//
//  PublicDeckView.swift
//  
//
//  Created by Rebecca Mello on 25/10/22.
//

import SwiftUI
import HummingBird
import Models
import Habitat
import Puffins
import StoreState
import Authentication

public struct PublicDeckView: View {
    var deck: ExternalDeck
    
    @StateObject private var interactor: PublicDeckInteractor = PublicDeckInteractor()
    @EnvironmentObject private var store: ShopStore
    @EnvironmentObject private var auth: AuthenticationModel
    
    @State private var showLogin = false
    
    public init(deck: ExternalDeck) {
        self.deck = deck
    }
    
    public var body: some View {
        let state = store.deckState
        
        Group {
            switch state.viewState {
            case .loaded:
                if let deck = state.deck {
                    loadedView(deck)
                } else {
                    Text("")
                }
            case .loading:
                loadingView()
            case .error:
                Text("error")
            }
        }
        .onAppear {
            if let deckId = store.deckState.deck?.id, deckId != deck.id {
                store.deckState = .init()
            }
            startUp()
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .animation(.linear, value: state.cards)
        .alert(NSLocalizedString("download_concluded", bundle: .module, comment: ""), isPresented: $store.deckState.shouldDisplayDownloadedAlert) {
            Button("Okay") {
                
            }
        }
        .viewBackgroundColor(HBColor.primaryBackground)
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        ProgressView()
    }
    
    @ViewBuilder
    private func loadedView(_ deck: ExternalDeck) -> some View {
        let state = store.deckState
        ScrollView {
            LazyVStack {
                deckHeader(deck)
                Section {
                    LazyVStack {
                        if store.deckState.cards.isEmpty {
                            LoadingFlashcardGrid()
                        } else {
                            flashcardGrid(store.deckState.cards)
                            if state.shouldLoadMore {
                                ProgressView()
                                    .onAppear {
                                        guard let id = deck.id else { return }
                                        interactor.send(.loadCards(id: id, page: store.deckState.currentPage))
                                    }
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Flashcards")
                            .font(.headline)
                        Spacer()
                    }
                }

            }
            .padding()
        }
        .onAppear {
            guard let id = deck.id else { return }
            let state = store.deckState
            interactor.send(.loadCards(id: id, page: state.currentPage))
        }
        .refreshable {
            guard let id = deck.id else { return }
            interactor.send(.reloadCards(id: id))
        }
        #if os(macOS)
        .sheet(isPresented: $showLogin) {
            AuthenticationView(model: auth)
        }
        #elseif os(iOS)
        .fullScreenCover(isPresented: $showLogin) {
            AuthenticationView(model: auth)
        }        #endif
    }
    
    @ViewBuilder
    private func flashcardGrid(_ cards: [ExternalCard]) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 12, alignment: .top)], spacing: 12) {
            ForEach(cards) { card in
                FlashcardCell(card: card) {}
                    .frame(height: 240)
                    .listRowSeparator(.hidden)
            }
        }
    }
    
    @ViewBuilder
    private func deckHeader(_ deck: ExternalDeck) -> some View {
        VStack {
            HeaderPublicDeckView(deck: deck)
            
            HStack {
                Button {
                    guard let id = deck.id else { return }
                    Task {
                        do {
                            let isSignedIn = try await auth.isSignedIn()
                            await MainActor.run {
                                showLogin = !isSignedIn
                                if isSignedIn {
                                    interactor.send(.downloadDeck(id: id))
                                }
                            }
                        } catch {
                            await MainActor.run {
                                showLogin = true
                            }
                        }
                    }
                } label: {
                    Label("Download", systemImage: "square.and.arrow.down")
                    .frame(minWidth: 140)
                    .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(HBColor.actionColor.opacity(0.15))
                .foregroundColor(HBColor.actionColor)
                .padding(.bottom)
                
                if let id = deck.id {
                    ShareLink(
                        item: DeepLinkURL.url(path: "store/\(id)")) {
                            Label {
                                Text("Share")
                            } icon: {
                                Image(systemName: "square.and.arrow.up")
                            }.bold()
                            
                            .frame(minWidth: 140)

                    }
                    .buttonStyle(.borderedProminent)
                    .tint(HBColor.actionColor.opacity(0.15))
                    .foregroundColor(HBColor.actionColor)
                    .padding(.bottom)
                }
            }
            
            if !deck.description.isEmpty {
                VStack(alignment: .leading) {
                    Text(deck.description)
                }
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding([.horizontal, .bottom], 16)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(HBColor.secondaryBackground)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
                .padding(.bottom)
            }
        }
    }
    
    private func startUp() {
        guard let id = deck.id else { return }
        interactor.bind(to: store)
        interactor.send(.loadDeck(id: id))
    }
}

struct PublicDeckView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                NavigationLink {
                    PublicDeckView(deck: ExternalDeck(id: "id", name: "Albums da Taylor Swift", description: "é Nene", icon: .brain, color: .lightPurple, category: .others, ownerId: "id", ownerName: "name", cardCount: 3))
                } label: {
                    Text("Navegar")
                }

            }
            .environmentObject(ShopStore())
        }
    }
}
