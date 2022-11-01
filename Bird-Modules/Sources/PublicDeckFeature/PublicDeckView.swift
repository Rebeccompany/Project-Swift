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
    
    public init(deck: ExternalDeck) {
        self.deck = deck
    }
    
    
    public var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HeaderPublicDeckView()
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
                        Text(deck.description)
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
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160, maximum: 180), spacing: 12, alignment: .top)], spacing: 12) {
                        ForEach(viewModel.cards) { card in
                            Text(card.front)
                                .frame(height: 300)
                        }
                        .listRowSeparator(.hidden)
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
            viewModel.fetchCards(deckId: deck.id)
        }
        .viewBackgroundColor(HBColor.primaryBackground)
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
