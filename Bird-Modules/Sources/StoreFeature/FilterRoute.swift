//
//  FilterRoute.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 04/12/22.
//

import Foundation
import Models

enum FilterRoute: Hashable {
    case search
    case category(category: DeckCategory)
}
