//
//  DifficultyStep.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 02/09/22.
//

import SwiftUI
import HummingBird

enum DifficultyStep: Int, CaseIterable, Identifiable {
    var id: Int {
        self.rawValue
    }
    
    case veryHard
    case hard
    case easy
    case veryEasy
    
    var buttonContent: DifficultyButtonContent {
        switch self {
        case .veryHard:
            return DifficultyButtonContent(image: "xmark.seal", label: "Muito Difícil", color: HBColor.veryHardColor)
        case .hard:
            return DifficultyButtonContent(image: "xmark", label: "Difícil", color: HBColor.hardColor)
        case .easy:
            return DifficultyButtonContent(image: "checkmark", label: "Fácil", color: HBColor.easyColor)
        case .veryEasy:
            return DifficultyButtonContent(image: "checkmark.seal", label: "Muito Fácil", color: HBColor.veryeasyColor)
        }
    }
}

struct DifficultyButtonContent {
    var image: String
    var label: String
    var color: Color
}
