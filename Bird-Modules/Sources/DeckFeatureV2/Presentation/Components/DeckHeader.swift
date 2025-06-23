//
//  DeckHeader.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 23/06/25.
//

import Models
import SwiftUI
import Foundation
import HummingBird

struct DeckHeader: View {
    let deck: Deck
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        ZStack(alignment:.bottomLeading) {
            symbol(size: .init(width: 50, height: 50), name: deck.icon, renderingMode: .template)
                .resizable(resizingMode: .tile)
                .font(.system(size: 35))
                .frame(height: 300)
                .foregroundStyle(HBColor.color(for: deck.color).mix(with: .white, by: 0.3))
                .background(HBColor.color(for: deck.color))
                .backgroundExtensionEffect()

            VStack(alignment: .leading, spacing: 4) {
                Text(deck.name)
                    .font(.title3.bold())
                    .foregroundStyle(.primary)

                if !deck.description.isEmpty {
                    Text(deck.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let date = deck.session?.date {
                    Text(nextDateLabel(for: date))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .glassEffect(
                .regular.interactive(false).tint(.clear),
                in: RoundedRectangle(cornerRadius: 24),
                isEnabled: true
            )
            .offset(y: -8)
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }

    private func nextDateLabel(for date: Date) -> String {
        let date = formatter.string(from: date)
        return "Próxima sessão Spixii: \(date)"
    }

    private func symbol(size: CGSize, name: String, renderingMode: Image.TemplateRenderingMode) -> Image {
        Image(size: size) { context in
            let symbol = Image(systemName: name).renderingMode(renderingMode)
            context.draw(symbol, at: .init(x: size.width / 2, y: size.height / 2), anchor: .center)
        }
    }
}
