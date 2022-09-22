//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 21/09/22.
//

public enum Components {
    case collection
    case deck
    case flashcard
}

public func getComponentString(component: Components) -> String {
    switch component {
    case .collection:
        return "coleção"
    case .deck:
        return "baralho"
    case .flashcard:
        return "flashcard"
    }
}
