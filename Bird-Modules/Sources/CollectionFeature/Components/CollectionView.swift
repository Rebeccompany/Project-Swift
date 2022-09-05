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
    var isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(info.numberOfDecks) Baralhos")
                    .padding(8)
                    .background(info.tagColor)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .padding(.bottom)
                
               
                 
                Text(info.collectionName)
                    .foregroundColor(isSelected ? info.tagColor : HBColor.collectionTextColor)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                    
            }
            
            Spacer()
            
        }.padding()
            .background(info.backgroundColor)
            .cornerRadius(8)
            .shadow(color: HBColor.shadowColor, radius: 3, x: 2, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(info.tagColor, lineWidth: isSelected ? 3 : 0)
            )
        
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(info: CollectionInfo(numberOfDecks: 10, collectionName: "coleção numro e oure i moboyf hfgfiotd ygoyufguol", backgroundColor: HBColor.secondaryBackground, tagColor: HBColor.collectionDarkPurple), isSelected: false)
            .frame(minHeight: 130)
            .accessibilityElement(children: /*@START_MENU_TOKEN@*/.contain/*@END_MENU_TOKEN@*/)
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
            .padding()
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
            .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
        
        CollectionView(info: CollectionInfo(numberOfDecks: 10, collectionName: "Todos", backgroundColor: HBColor.secondaryBackground, tagColor: HBColor.collectionDarkPurple), isSelected: true)
            .frame(minHeight: 130)
            .padding()
            .background(HBColor.primaryBackground)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
    }
}
