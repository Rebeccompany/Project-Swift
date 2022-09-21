//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 21/09/22.
//

enum Components: String {
    case collection
    case deck
    case flashcard
}

func getComponentString(component: Components) -> String {
    switch component{
        case .collection:
            return "coleção"
        case .deck:
            return "baralho"
        case .flashcard:
            return "flashcard"
    }
}

