//
//  SidebarRoutes.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 13/09/22.
//

import Foundation

public enum SidebarRoute: Hashable {
    case allDecks
    case store
    case decksFromCollection(_ collection: DeckCollection)
}
