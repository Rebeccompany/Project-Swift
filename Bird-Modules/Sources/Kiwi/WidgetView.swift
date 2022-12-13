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
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
            .viewBackgroundColor(HBColor.primaryBackground)
            
        default:
            mediumWidget
            .viewBackgroundColor(HBColor.primaryBackground)
        }
        
    }
    
    @ViewBuilder
    private var smallWidget: some View {
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
    }
    
    
    @ViewBuilder
    private var mediumWidget: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Baralhos Diários")
                    .lineLimit(nil)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(HBColor.collectionTextColor)
                Spacer()
                widgetDateBuilder(date: Date())
            }
            
            if baralhos.isEmpty {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Piu! Dia de Descanso!")
                            .lineLimit(nil)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(HBColor.collectionOrange)
                        Text("Sem estudos por hoje! Até logo!")
                            .lineLimit(nil)
                            .font(.title3)
                            .fontWeight(.light)
                            .foregroundColor(HBColor.collectionGray)
                    }
                    HBImages.spixiiBeach
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                
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
