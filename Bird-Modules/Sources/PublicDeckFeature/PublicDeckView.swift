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

public struct PublicDeckView: View {
    var deck: ExternalDeck
    
    @StateObject private var viewModel: PublicDeckViewModel = PublicDeckViewModel()
    @StateObject private var interactor: PublicDeckInteractor = PublicDeckInteractor()
    @StateObject private var store: Store<PublicDeckState> = Store(state: PublicDeckState())
    
    public init(deck: ExternalDeck) {
        self.deck = deck
    }
    
    
    public var body: some View {
        ScrollView {
            VStack {
                VStack {
                    if let deck = store.state.deck {
                        HeaderPublicDeckView(deck: deck)
                    }
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
                        Text(store.state.deck?.description ?? "")
                    }
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal, .bottom], 16)
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .padding(.bottom)
                }
                
                Section {
                    LazyVStack {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 12, alignment: .top)], spacing: 12) {
                            ForEach(store.state.cards) { card in
                                FlashcardCell(card: card) {}
                                    .frame(height: 240)
                                    .onAppear {
                                        if card.id == store.state.cards.last?.id {
                                            interactor.send(.loadCards(id: deck.id, page: store.state.currentPage))
                                        }
                                    }
                                    
                            }
                            .listRowSeparator(.hidden)
                            
                            
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
            startUp()
        }
        .viewBackgroundColor(HBColor.primaryBackground)
    }
    
    private func startUp() {
        interactor.bind(to: store)
        interactor.send(.loadDeck(id: deck.id))
        interactor.send(.loadCards(id: deck.id, page: store.state.currentPage))
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                NavigationLink {
                    PublicDeckView(deck: ExternalDeck(id: "id", name: "Albums da Taylor Swift", description: "é Nene", icon: .brain, color: .lightPurple, category: .others))
                } label: {
                    Text("Navegar")
                }

            }
        }
    }
}
