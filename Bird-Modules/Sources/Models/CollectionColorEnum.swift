//
//  File.swift
//  
//
//  Created by Marcos Chevis on 02/09/22.
//

import Foundation

public enum CollectionColor: Int, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case lightBlue
    case darkPurple
    case lightPurple
    case pink
    case otherPink
    case beigeBrown
    case gray
    case darkBlue
    
    public static func getColorString(_ colorName: CollectionColor) -> String {
        switch colorName {
        case .red:
            return "vermelha"
        case .orange:
            return "laranja"
        case .yellow:
            return "amarelo"
        case .green:
            return "verde"
        case .lightBlue:
            return "azul claro"
        case .darkPurple:
            return "roxo escuro"
        case .lightPurple:
            return "roxo claro"
        case .pink:
            return "rosa"
        case .otherPink:
            return "salmão"
        case .beigeBrown:
            return "bege"
        case .gray:
            return "cinza"
        case .darkBlue:
            return "azul escuro"
        }
    }
}
