//
//  PublicSection.swift
//  
//
//  Created by Rebecca Mello on 25/10/22.
//

import SwiftUI
import Models
import HummingBird

struct PublicSection: View {
    var section: ExternalSection
    
    var body: some View {
        Section {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 16, alignment: .top)], spacing: 16) {
                ForEach(section.decks) { deck in
                    NavigationLink(value: deck) {
                        PublicDeckCell(deck: deck)
                    }
                    .frame(height: 200)
#if os(macOS)
                    .buttonStyle(.plain)
#endif
                }
                .cornerRadius(12)
            }
        } header: {
            HStack {
                Text(LocalizedStringKey(stringLiteral: section.title), bundle: .module)
                    .font(.title3.bold())
               
                Spacer()
                NavigationLink(value: FilterRoute.category(category: DeckCategory(rawValue: section.title) ?? .others)) {
                    HStack {
                        Text("see_all".localized(.module))
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(HBColor.actionColor)
#if os(macOS)
                    .padding()
#endif
                }
#if os(macOS)
                .buttonStyle(.plain)
#endif
            }
        }
        .padding([.bottom, .leading, .trailing], 16)
    }
}
