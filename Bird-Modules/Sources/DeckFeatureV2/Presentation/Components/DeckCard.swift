//
//  DeckCard.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 23/06/25.
//

import Models
import HummingBird
import SwiftUI

struct DeckCard: View {
    let card: Card
    @Bindable var model: DeckViewModel

    var body: some View {
        FlashcardCell(card: card) {
            model.presentSheet(for: .editCard(card))
        }
        .frame(height: 230)
        .contextMenu {
            Button {
                model.presentSheet(for: .editCard(card))
            } label: {
                Label(NSLocalizedString("editar_flashcard", bundle: .module, comment: ""),
                      systemImage: "pencil")
            }

            Button(role: .destructive) {

            } label: {
                Label(NSLocalizedString("deletar_flashcard", bundle: .module, comment: ""),
                      systemImage: "trash.fill")
            }
        }

    }
}
