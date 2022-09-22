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
        VStack {
            ZStack(alignment: .top) {
                rectangle
                    .scaleEffect(0.88)
                    .offset(y: -24)
                rectangle
                    .scaleEffect(0.94)
                    .offset(y: -12)
                ZStack {
                    rectangle
                    Image(systemName: info.icon)
                        .font(.system(size: 48))
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 4)
                    
            Text(info.name)
                .lineLimit(2)
            Text("\(info.numberOfCards) cartas")
                .foregroundColor(.secondary)
        }
    }
    
    
    @ViewBuilder
    var rectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(HBColor.color(for: info.color))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 3)
            }
            .frame(height: 116)
    }
}

struct DeckCell_Previews: PreviewProvider {
    static var previews: some View {
        DeckCell(info: DeckCellInfo(icon: "flame", numberOfCards: 10, name: "Nome do Baralho 1", color: .otherPink))
            .frame(width: 180, height: 100)
            .previewLayout(.sizeThatFits)
            .viewBackgroundColor(Color.blue)
    }
}
