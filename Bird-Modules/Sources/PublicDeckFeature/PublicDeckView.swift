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
import StoreState

public struct PublicDeckView: View {
    #warning("isso aqui ta estranho")
    var deck: ExternalDeck
    
    @StateObject private var interactor: PublicDeckInteractor = PublicDeckInteractor()
    @EnvironmentObject private var store: ShopStore
    
    public init(deck: ExternalDeck) {
        self.deck = deck
    }
    
    public var body: some View {
        let state = store.deckState
        
        Group {
            if let deck = state.deck {
                loadedView(deck)
            } else {
                loadingView()
            }
        }
        .onAppear {
            store.deckState = .init()
            startUp()
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.linear, value: state.cards)
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
                    
                } label: {
                    Image(systemName: "square.and.arrow.down")
                    Text("Download")
                }
                .bold()
                .buttonStyle(.borderedProminent)
                .tint(HBColor.actionColor.opacity(0.15))
                .foregroundColor(HBColor.actionColor)
                .padding(.bottom)
                
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                    Text("Compartilhar")
                }
                .bold()
                .buttonStyle(.borderedProminent)
                .tint(HBColor.actionColor.opacity(0.15))
                .foregroundColor(HBColor.actionColor)
                .padding(.bottom)
            }
            
            VStack(alignment: .leading) {
                Text(store.deckState.deck?.description ?? "")
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
                    PublicDeckView(deck: ExternalDeck(id: "id", name: "Albums da Taylor Swift", description: "é Nene", icon: .brain, color: .lightPurple, category: .others))
                } label: {
                    Text("Navegar")
                }

            }
            .environmentObject(ShopStore())
        }
    }
}
