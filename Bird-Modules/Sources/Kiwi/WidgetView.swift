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
    public var Baralhos: [Baralhos] = []
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
            
            for Baralho in Baralhos {
                HStack {
                    Divider()
                        .frame(width: 5, height: 50)
                        .overlay(HBColor.collectionDarkPurple)
                        .cornerRadius(30)
                    ZStack {
                        Circle()
                            .frame(width: 35)
                            .foregroundColor(HBColor.collectionDarkPurple)
                            .brightness(0.3)
                        Image(systemName: "gamecontroller")
                            .foregroundColor(HBColor.collectionDarkPurple)
                    }
                    VStack {
                        Text("Nome do Baralho")
                            .foregroundColor(HBColor.collectionTextColor)
                            .fontWeight(.semibold)
                        
                        Text("\(numBaralhos) cartas para hoje")
                            .foregroundColor(HBColor.collectionGray)
                            .fontWeight(.light)
                    }
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
        WidgetView(Baralhos: [Baralhos], numBaralhos: 5)
    }
}
