//
//  DifficultyStep.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 02/09/22.
//

import SwiftUI
import HummingBird
import Models

#if !os(macOS)
struct DifficultyButtonContent {
    var image: String
    var label: String
    var color: Color
    
    static func getbuttonContent(for userGrade: UserGrade ) -> DifficultyButtonContent {
        let generator = UINotificationFeedbackGenerator()
        switch userGrade {
        case .wrongHard:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "hand.raised.slash", label: NSLocalizedString("muito_dificil", bundle: .module, comment: ""), color: HBColor.veryHardColor)
        case .wrong:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "hand.thumbsdown", label: NSLocalizedString("dificil", bundle: .module, comment: ""), color: HBColor.hardColor)
        case .correct:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "hand.thumbsup", label: NSLocalizedString("facil", bundle: .module, comment: ""), color: HBColor.easyColor)
        case .correctEasy:
            generator.notificationOccurred(.success)
            return DifficultyButtonContent(image: "hands.sparkles", label: NSLocalizedString("muito_facil", bundle: .module, comment: ""), color: HBColor.veryEasyColor)
        }
    }
    
}
#else

struct DifficultyButtonContent {
    var image: String
    var label: String
    var color: Color
    
    static func getbuttonContent(for userGrade: UserGrade ) -> DifficultyButtonContent {
        switch userGrade {
        case .wrongHard:
            return DifficultyButtonContent(image: "hand.raised.slash", label: NSLocalizedString("muito_dificil", bundle: .module, comment: ""), color: HBColor.veryHardColor)
        case .wrong:
            return DifficultyButtonContent(image: "hand.thumbsdown", label: NSLocalizedString("dificil", bundle: .module, comment: ""), color: HBColor.hardColor)
        case .correct:
            return DifficultyButtonContent(image: "hand.thumbsup", label: NSLocalizedString("facil", bundle: .module, comment: ""), color: HBColor.easyColor)
        case .correctEasy:
            return DifficultyButtonContent(image: "hands.sparkles", label: NSLocalizedString("muito_facil", bundle: .module, comment: ""), color: HBColor.veryEasyColor)
        }
    }
}
#endif
