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
import Storage

struct DeckView: View {
    @ObservedObject
    var viewModel: DeckViewModel
    @State
    var shouldDisplay: Bool = false
    
    var body: some View {
        List {
            Button("Estudar Deck") {
                
            }
            .buttonStyle(LargeButtonStyle())
            .listRowInsets(.zero)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .padding()
            
            ForEach(viewModel.cards) {card in
                FlashcardCell(card: card) {
                    shouldDisplay = true
                }
                
                .background(
                    NavigationLink {
                        FlashcardCell(card: card) {}
                            .padding()
                    } label: {
                        EmptyView()
                    }
                )
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchFieldContent)
        .navigationTitle(viewModel.deck.name)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Group {
                    Button("Editar") {}
                    Button {} label: {
                        Image(systemName: "plus")
                    }
                }
                .foregroundColor(HBColor.actionColor)
            }
        }
    }
}

struct FlashcardCell: View {
    var card: Card
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .center) {
                HStack {
                    Text("Frente")
                        .font(.system(size: 15))
                    Spacer()
                }
                Spacer()
                Text(cardText(card.front))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(8)
            .frame(minHeight: 150)
            .background(HBColor.getHBColrFromCollectionColor(card.color))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 3)
            )
        }
    }
    
    private func cardText(_ content: AttributedString) -> AttributedString {
        var content = content
        content.swiftUI.font = .body
        content.swiftUI.foregroundColor = .white
        
        return content
    }
}

extension EdgeInsets {
    static var zero: EdgeInsets {
        EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

final class DeckViewModel: ObservableObject {
    @Published var deck: Deck
    @Published var searchFieldContent: String
    @Published var cards: [Card]
    
    private var deckRepository: DeckRepositoryProtocol
    
    init(deck: Deck, deckRepository: DeckRepositoryProtocol = DeckRepository(collectionId: nil)) {
        self.deck = deck
        self.searchFieldContent = ""
        self.deckRepository = deckRepository
        self.cards = [DeckView_Previews.dummy, DeckView_Previews.dummy, DeckView_Previews.dummy, DeckView_Previews.dummy, DeckView_Previews.dummy]
    }
}

struct DeckView_Previews: PreviewProvider {
    static var dummy: Card {
        let deckId = UUID(uuidString: "25804f37-a401-4211-b8d1-ac2d3de53775")!
        let frontData = "Toxoplasmose: exame e seus respectivo tempo e tratamento".data(using: .utf8)!
        let backData =  ". Sorologia (IgM,IgG) -&gt; Teste de Avidez (&lt;30% aguda, &gt;60% cronica)&nbsp;<br>. Espiramicina 3g -VO 2 cp de 500mg por 8/8h&nbsp;".data(using: .utf8)!
        
        let frontNSAttributedString = try! NSAttributedString(data: frontData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let backNSAttributedString = try! NSAttributedString(data: backData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        let wp = WoodpeckerCardInfo(step: 1,
                                    isGraduated: true,
                                    easeFactor: 2.5,
                                    streak: 1,
                                    interval: 1,
                                    hasBeenPresented: true)
        
        return Card(id: UUID(), front: AttributedString(frontNSAttributedString), back: AttributedString(backNSAttributedString), color: .allCases.randomElement()!, datesLogs: dateLog, deckID: deckId, woodpeckerCardInfo: wp, history: [])
    }
    
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
                        collectionsIds: [],
                        cardsIds: [],
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
