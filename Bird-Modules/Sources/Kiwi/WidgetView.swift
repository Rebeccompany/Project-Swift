//
//  File.swift
//  
//
//  Created by Rebecca Mello on 12/12/22.
//

import SwiftUI
import WidgetKit
import HummingBird
import Models

struct WidgetView: View {
    public var baralhos: [Deck]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Baralhos Diários")
                .lineLimit(nil)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(HBColor.collectionTextColor)
            widgetDateBuilder(date: Date())
            if baralhos.isEmpty {
                Text("Piu! Dia de Descanso!")
                    .lineLimit(nil)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(HBColor.collectionOrange)
                HBImages.spixiiDrinkingWater
                    .resizable()
                    .frame(width: 100, height: 80)
                
            }
            else {
                ForEach(baralhos.prefix(2)) { baralho in
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
                            Image(systemName: "\(baralho.icon)")
                                .foregroundColor(HBColor.collectionDarkPurple)
                        }
                        VStack {
                            Text("\(baralho.name)")
                                .foregroundColor(HBColor.collectionTextColor)
                                .fontWeight(.semibold)
                            
                            Text("\(baralho.cardsIds.count) cartas para hoje")
                                .foregroundColor(HBColor.collectionGray)
                                .fontWeight(.light)
                        }
                    }
                }
                
                if baralhos.count > 2 {
                    HStack {
                        Image(systemName: "ellipsis.circle")
                        Text("Mais \(baralhos.count - 2) baralhos")
                            .foregroundColor(HBColor.collectionTextColor)
                    }
                }
            }
        }
        .viewBackgroundColor(HBColor.primaryBackground)
    }
}

func widgetDateBuilder(date: Date) -> some View {
    Text(date, style: .date)
        .lineLimit(nil)
        .font(.title3)
        .fontWeight(.medium)
        .foregroundColor(HBColor.actionColor)
}


struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(baralhos: [])
    }
}
