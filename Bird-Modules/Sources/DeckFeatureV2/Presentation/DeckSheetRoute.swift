//
//  DeckSheetRoute.swift
//  Bird-Modules
//
//  Created by Lua Ferreira de Carvalho on 23/06/25.
//
import Models

enum DeckSheetRoute: Identifiable {
    var id: String {
        switch self {
        case .addCard:
            "addCard"
        case .importCards:
            "importCards"
        case .editCard(let card):
            card.id.uuidString
        }
    }

    case addCard
    case importCards
    case editCard(Card)
}

enum DeckFullScreenRoute: Identifiable {
    var id: String {
        switch self {
        case .study(let studyMode):
            studyMode.rawValue
        }
    }

    case study(StudyMode)
}
