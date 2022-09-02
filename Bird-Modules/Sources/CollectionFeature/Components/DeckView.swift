//
//  DeckView.swift
//  
//
//  Created by Nathalia do Valle Papst on 02/09/22.
//

import SwiftUI

struct DeckView: View {
    var backgroundColor: Color
    var iconName: String
    var numberOfCards: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40, alignment: .topLeading)
                
                    Image(systemName: iconName).foregroundColor(backgroundColor)
                }
        
                Spacer()
                
                HStack {
                    Text("\(numberOfCards) cartas")
                        .padding(8)
                        .background(.white)
                        .cornerRadius(10)
                        .foregroundColor(backgroundColor)
                        .font(.system(size: 10))
                }
                
            }
            
            Spacer()
            Text("Nome do Baralho 1")
                .foregroundColor(.white)
                .font(.system(size: 15))
            
        }.frame(width: 250, height: 125)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
            ).padding()
            .background(Color(red: 242, green: 242, blue: 247))
            
    }
}

struct DeckView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            DeckView(backgroundColor: HBColor.collectionOtherPink, iconName: "gamecontroller", numberOfCards: 12)
                .previewLayout(.sizeThatFits)
        }
    }
}
