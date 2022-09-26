//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 21/09/22.
//

import SwiftUI

public struct EmptyStateView: View {
    var component: Components
    
    public init(component: Components) {
        self.component = component
    }
    
    public var body: some View {
        VStack {
            if component == Components.collection {
                HBAssets.noCollectionsEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .accessibilityLabel(Text("Sem Coleção"))
            } else if component == Components.deck {
                HBAssets.noDecksEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .accessibilityLabel(Text("Sem Baralho"))
            } else {
                HBAssets.noFlashcardsEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .accessibilityLabel(Text("Sem Flashcards"))
            }
            
            Text("Piu! Sem " + getComponentString(component: component) + "!")
                .foregroundColor(HBColor.actionColor)
                .bold()
                .padding(.top, 10)
            
            
            if component == Components.collection {
                Text("Clique em + para criar uma nova coleção")
                    .foregroundColor(HBColor.collectionGray)
                    .font(.system(size: 15))
            } else if component == Components.deck {
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
        EmptyStateView(component: Components.collection)
    }
}