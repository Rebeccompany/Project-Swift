//
//  CollectionView.swift
//  
//
//  Created by Nathalia do Valle Papst on 02/09/22.
//

import SwiftUI
import HummingBird

struct CollectionView: View {
    var info: CollectionInfo
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(info.numberOfDecks) Baralhos")
                    .padding(8)
                    .background(info.tagColor)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.caption2.bold())
                
                Spacer()
                 
                Text(info.collectionName)
                    .foregroundColor(HBColor.collectionTextColor)
                    .fontWeight(.bold)
                    
            }
            
            Spacer()
            
        }.padding()
            .background(info.backgroundColor)
            .cornerRadius(8)
        .shadow(color: HBColor.shadowColor, radius: 3, x: 2, y: 3)
        
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(info: CollectionInfo(numberOfDecks: 10, collectionName: "Todos", backgroundColor: HBColor.secondaryBackground, tagColor: HBColor.collectionDarkPurple))
            .frame(height: 130)
            .padding()
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
        
        CollectionView(info: CollectionInfo(numberOfDecks: 10, collectionName: "Todos", backgroundColor: HBColor.secondaryBackground, tagColor: HBColor.collectionDarkPurple))
            .frame(height: 130)
            .padding()
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
