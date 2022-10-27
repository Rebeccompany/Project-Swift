//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 25/10/22.
//

import SwiftUI
import Models

struct PublicSection: View {
    var section: ExternalSection
    
    var body: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 16, alignment: .top)], spacing: 16) {
                ForEach(section.decks) { deck in
                    PublicDeckView(deck: deck, numberOfCopies: 10, author: "Spixii")
                        .frame(height: 200)
                }
                .cornerRadius(12)
            }
        } header: {
            Text(section.title)
                .font(.title3.bold())
        }
        .padding([.bottom, .leading, .trailing], 16)
    }
}
