//
//  SearchDeckCell.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/12/22.
//

import Models
import SwiftUI
import HummingBird

struct SearchDeckCell: View {
    let deck: ExternalDeck
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: deck.icon.rawValue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .frame(width: 30, height: 30, alignment: .center)
                    .background {
                        Circle().fill(HBColor.color(for: deck.color))
                    }
                    .padding(.leading)
                    .padding(.trailing, 4)
                VStack(alignment: .leading) {
                    Text(deck.name)
                        .font(.headline)
                    if !deck.description.isEmpty {
                        Text(deck.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    HStack {
                        Text("made by \(deck.ownerName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("\(deck.cardCount) Cards")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .padding(.trailing)
                    .foregroundColor(.secondary)
            }
            Divider()
                .padding(.horizontal)
        }
        .foregroundColor(.primary)
    }
}
