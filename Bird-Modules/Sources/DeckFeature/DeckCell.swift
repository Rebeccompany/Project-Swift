//
//  DeckCell.swift
//  
//
//  Created by Nathalia do Valle Papst on 14/09/22.
//

import SwiftUI
import HummingBird
import Models

struct DeckCell: View {
    var info: DeckCellInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: info.icon)
                    .font(.system(size: 17))
                    .frame(width: 34, height: 34)
                    .foregroundColor(HBColor.getHBColrFromCollectionColor(info.color))
                    .background(
                        Circle()
                            .foregroundColor(.white)
                    )
                
                Spacer()
                
                HStack {
                    Text("\(info.numberOfCards)")
                        .font(.system(size: 12))
                        .foregroundColor(HBColor.getHBColrFromCollectionColor(info.color))
                        .fontWeight(.bold)
                        .padding(.trailing, -7)
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                        .font(.system(size: 12))
                        .foregroundColor(HBColor.getHBColrFromCollectionColor(info.color))
                }
                .padding(3)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(.white)
                )
            }
            .padding()
                    
            Text(info.name)
                .foregroundColor(.white)
                .padding(.leading)
                .padding(.bottom)
        }
        .viewBackgroundColor(HBColor.getHBColrFromCollectionColor(info.color))
        .cornerRadius(10)
    }
}

struct DeckCell_Previews: PreviewProvider {
    static var previews: some View {
        DeckCell(info: DeckCellInfo(icon: "flame", numberOfCards: 10, name: "Nome do Baralho 1", color: .otherPink))
            .frame(width: 180, height: 100)
            .previewLayout(.sizeThatFits)
    }
}
