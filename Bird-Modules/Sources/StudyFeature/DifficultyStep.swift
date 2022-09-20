//
//  DifficultyStep.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 02/09/22.
//

import SwiftUI
import HummingBird
import Models

struct DifficultyButtonContent {
    var image: String
    var label: String
    var color: Color
    
    static func getbuttonContent(for userGrade: UserGrade ) -> DifficultyButtonContent {
        switch userGrade {
        case .wrongHard:
            return DifficultyButtonContent(image: "xmark.seal", label: "Muito Difícil", color: HBColor.veryHardColor)
        case .wrong:
            return DifficultyButtonContent(image: "xmark", label: "Difícil", color: HBColor.hardColor)
        case .correct:
            return DifficultyButtonContent(image: "checkmark", label: "Fácil", color: HBColor.easyColor)
        case .correctEasy:
            return DifficultyButtonContent(image: "checkmark.seal", label: "Muito Fácil", color: HBColor.veryeasyColor)
        }
    }
    
}
