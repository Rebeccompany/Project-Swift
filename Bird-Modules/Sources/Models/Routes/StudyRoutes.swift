//
//  StudyRoutes.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 13/09/22.
//

import Foundation

public enum StudyRoute: Hashable {
    case deck(_ deck: Deck)
    case card(_ card: Card)
}
