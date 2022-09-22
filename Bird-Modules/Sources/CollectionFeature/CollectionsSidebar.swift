//
//  SwiftUIView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models
import HummingBird

public struct CollectionsSidebar: View {
    @Environment(\.editMode) private var editMode
    private var collections: [DeckCollection]
    @Binding private var selection: SidebarRoute?
    private var isCompact: Bool
    private let deleteAction: (IndexSet) -> Void
    private let editAction: (DeckCollection) -> Void
    
    public init(
        collections: [DeckCollection],
        selection: Binding<SidebarRoute?>,
        isCompact: Bool,
        deleteAction: @escaping (IndexSet) -> Void,
        editAction: @escaping (DeckCollection) -> Void
    ) {
        self.collections = collections
        self._selection = selection
        self.isCompact = isCompact
        self.deleteAction = deleteAction
        self.editAction = editAction
    }
    
    public var body: some View {
        List(selection: $selection) {
            NavigationLink(value: SidebarRoute.allDecks) {
                Label("Todos os baralhos", systemImage: "square.stack")
            }
            .listRowBackground(
                isCompact ? HBColor.secondaryBackground : nil
            )
            
            Section {
                ForEach(collections) { collection in
                    NavigationLink(value: SidebarRoute.decksFromCollection( collection)) {
                        HStack {
                            Label(collection.name, systemImage: collection.icon.rawValue)
                            Spacer()
                            if editMode?.wrappedValue.isEditing ?? false {
                                Image(systemName: "info.circle")
                                    .foregroundColor(HBColor.actionColor)
                                    .onTapGesture {
                                        editAction(collection)
                                    }
                                    .accessibility(addTraits: .isButton)
                            }
                        }
                    }
                    .listRowBackground(
                        isCompact ? HBColor.secondaryBackground : nil
                    )
                }
                .onDelete(perform: deleteAction)
                
            } header: {
                Text("Coleções")
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            VStack {
                if collections.isEmpty {
                    VStack {
                        EmptyStateView(component: .collection)
                        Button {
#warning("fazer ir pro modal de criar colecao")
                        } label: {
                            Text("Criar Coleção")
                        }
                        .buttonStyle(LargeButtonStyle(isDisabled: false))
                        .padding()
                    }
                    
                }
            }
        )
        .viewBackgroundColor(HBColor.primaryBackground)
        
    }
    
}

struct CollectionsSidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            CollectionsSidebar(collections: [DeckCollection(id: UUID(), name: "Coleção", icon: .atom, datesLogs: DateLogs(), decksIds: [])], selection: .constant(.allDecks), isCompact: false) { _ in } editAction: { _ in }
        } detail: {
            Text("Empty")
        }
        
    }
}
