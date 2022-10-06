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
                    .accessibilityLabel(Text("sem_colecao", bundle: .module))
            } else if component == Components.deck {
                HBAssets.noDecksEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .accessibilityLabel(Text("sem_deck", bundle: .module))
            } else {
                HBAssets.noFlashcardsEmptyState
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .accessibilityLabel(Text("sem_flashcards", bundle: .module))
            }
            
            Text(NSLocalizedString("piu", bundle: .module, comment: "") + getComponentString(component: component) + "!")
                .foregroundColor(HBColor.actionColor)
                .bold()
                .padding(.top, 10)
            
            
            if component == Components.collection {
                Text("clicar_para_criar_colecao", bundle: .module)
                    .foregroundColor(HBColor.collectionGray)
                    .font(.system(size: 15))
            } else if component == Components.deck {
                Text("clicar_para_criar_deck", bundle: .module)
                    .foregroundColor(HBColor.collectionGray)
                    .font(.system(size: 15))
            } else {
                Text("clicar_para_criar_flashcard", bundle: .module)
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
