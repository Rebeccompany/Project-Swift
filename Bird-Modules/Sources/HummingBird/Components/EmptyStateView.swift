//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 21/09/22.
//

import SwiftUI

struct EmptyStateView: View {
    var component: String = ""
    
    var body: some View {
        VStack {
            if component == "coleção" {
                HBAssets.noCollectionsEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            } else if component == "baralho" {
                HBAssets.noDecksEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            } else {
                HBAssets.noFlashcardsEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
            
            Text("Piu! Sem " + component + "!")
                .foregroundColor(HBColor.actionColor)
                .bold()
                .padding(.top, 10)
            
            
            if component == "coleção" {
                Text("Clique em + para criar uma nova coleção")
                    .foregroundColor(HBColor.collectionGray)
                    .font(.system(size: 15))
            } else if component == "baralho" {
                Text("Clique em + para criar um novo baralho")
                    .foregroundColor(HBColor.collectionGray)
                    .font(.system(size: 15))
            } else {
                Text("Clique em + para criar um novo flashcard")
                    .foregroundColor(HBColor.collectionGray)
                    .font(.system(size: 15))
            }
        }
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(component: getComponentString(component: .flashcard))
    }
}
