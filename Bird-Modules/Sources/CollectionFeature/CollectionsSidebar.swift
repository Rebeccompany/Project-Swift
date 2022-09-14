//
//  SwiftUIView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models

#warning("IMPLEMENTAR ICONE DA COLEÇÃO")
public struct CollectionsSidebar: View {
    private var collections: [DeckCollection]
    @Binding private var selection: SidebarRoute?
    
    public init(collections: [DeckCollection], selection: Binding<SidebarRoute?>) {
        self.collections = collections
        self._selection = selection
    }
    
    public var body: some View {
        List(selection: $selection) {
            NavigationLink(value: SidebarRoute.allDecks) {
                Label("Todos os baralhos", systemImage: "square.stack")
            }
            
            Section {
                if collections.isEmpty {
                    VStack {
                        Text("Não existem coleções criadas no momento")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                } else {
                    ForEach(collections) { collection in
                        NavigationLink(value: SidebarRoute.decksFromCollection(id: collection.id)) {
                            Text(collection.name)
                        }
                    }
                }
                
            } header: {
                Text("Coleções")
            }
        }
    }
}

struct CollectionsSidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            CollectionsSidebar(collections: [DeckCollection(id: UUID(), name: "Coleção", color: .darkBlue, datesLogs: DateLogs(), decksIds: [])], selection: .constant(.allDecks))
        } detail: {
            Text("Empty")
        }

    }
}
