//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/10/22.
//

import SwiftUI
import Models
import HummingBird

struct ReviewImportView: View {
    @EnvironmentObject private var viewModel: ImportViewModel
    @Binding var isPresentingSheet: Bool
    @Binding var cards: [Card]
    let deck: Deck
    
    var body: some View {
        List {
            ForEach(cards) { card in
                HStack {
                    FlashcardCell(card: card) {}
                        .frame(height: 180)
                        .padding(.trailing, 4)
                    FlashcardCell(card: card, isFront: false) {}
                        .frame(height: 180)
                        .padding(.leading, 4)
                }
                .accessibilityElement(children: .combine)
                .padding(8)
            }
            .onDelete { i in
                cards.remove(atOffsets: i)
            }
        }
        .navigationTitle(Text("import_review_title", bundle: .module))
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.save(cards, to: deck)
                    isPresentingSheet = false
                } label: {
                    Text("add_button", bundle: .module)
                }

            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(role: .cancel) {
                    isPresentingSheet = false
                } label: {
                    Text("cancel", bundle: .module)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
