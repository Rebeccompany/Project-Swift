//
//  File.swift
//  
//
//  Created by Rebecca Mello on 12/12/22.
//

import SwiftUI
import WidgetKit
import HummingBird

struct WidgetView: View {
    public var numBaralhos: Int
    var body: some View {
        VStack(alignment: .leading) {
            Text("Baralhos Diários")
                .lineLimit(nil)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(HBColor.collectionTextColor)
            Text("Dia, dd/MM")
                .lineLimit(nil)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(HBColor.actionColor)
            
            HStack {
                Divider()
                    .frame(width: 4, height: 50)
                    .overlay(HBColor.collectionRed)
                    .cornerRadius(30)
                ZStack {
                    Circle()
                        .frame(width: 35)
                        .foregroundColor(.blue)
                    Image(systemName: "gamecontroller")
                        .foregroundColor(HBColor.collectionRed)
                }
                VStack {
                    Text("Nome do Baralho")
                        .foregroundColor(HBColor.collectionTextColor)
                    Text("\(numBaralhos) cartas para hoje")
                        .foregroundColor(HBColor.collectionTextColor)
                }
            }
            
            
            if numBaralhos > 2 {
                HStack {
                    Image(systemName: "ellipsis.circle")
                    Text("Mais \(numBaralhos) baralhos")
                        .foregroundColor(HBColor.collectionTextColor)
                }
            }
        }
        .viewBackgroundColor(HBColor.primaryBackground)
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(numBaralhos: 5)
    }
}
