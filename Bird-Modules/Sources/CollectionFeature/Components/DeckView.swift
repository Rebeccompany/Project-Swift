//
//  DeckView.swift
//  
//
//  Created by Nathalia do Valle Papst on 02/09/22.
//

import SwiftUI
import HummingBird

struct DeckView: View {
    let info: DeckInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: info.iconName)
                    .foregroundColor(info.backgroundColor)
                    .frame(width: 35, height: 35)
                    .background(
                        Circle()
                            .fill(.white)

                    )
        
                Spacer()
                
                HStack {
                    Text("\(info.numberOfCards) cartas")
                        .padding(8)
                        .background(.white)
                        .cornerRadius(10)
                        .foregroundColor(info.backgroundColor)
                        .font(.caption2.bold())
                }
                
            }
            
            Spacer()
            Text(info.deckName)
                .foregroundColor(.white)
                .fontWeight(.bold)
            
        }
            .padding()
            .background(info.backgroundColor)
            .cornerRadius(8)
            .shadow(color: HBColor.shadowColor, radius: 3, x: 2, y: 3)
            
    }
}

struct DeckView_Preview: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [GridItem(.flexible(minimum: 170, maximum: 200)), GridItem(.flexible(minimum: 170, maximum: 200))], spacing: 8) {
            DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                .frame(height: 100)
            DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                .frame(height: 100)
            DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                .frame(height: 100)
            DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                .frame(height: 100)
        }.padding()
            
            List {
                DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                    .frame(height: 120)
                DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                    .frame(height: 120)
                DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                    .frame(height: 120)
                DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                    .frame(height: 120)
                DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                    .frame(height: 120)
                DeckView(info: DeckInfo(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 10, deckName: "Nome do Baralho 1"))
                    .frame(height: 120)
                    
            }
            .listStyle(.plain)
            .preferredColorScheme(.dark)
        
    }
}
