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
        let generator = UINotificationFeedbackGenerator()
        switch userGrade {
        case .wrongHard:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "xmark.seal", label: NSLocalizedString("muito_dificil", bundle: .module, comment: ""), color: HBColor.veryHardColor)
        case .wrong:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "xmark", label: NSLocalizedString("dificil", bundle: .module, comment: ""), color: HBColor.hardColor)
        case .correct:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "checkmark", label: NSLocalizedString("facil", bundle: .module, comment: ""), color: HBColor.easyColor)
        case .correctEasy:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "checkmark.seal", label: NSLocalizedString("muito_facil", bundle: .module, comment: ""), color: HBColor.veryeasyColor)
        }
    }
    
}
