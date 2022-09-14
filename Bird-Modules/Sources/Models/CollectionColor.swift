//
//  File.swift
//  
//
//  Created by Marcos Chevis on 02/09/22.
//

import Foundation

public enum CollectionColor: Int, CaseIterable, Hashable {
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
            return "Vermelho"
        case .orange:
            return "Laranja"
        case .yellow:
            return "Amarelo"
        case .green:
            return "Verde"
        case .lightBlue:
            return "Azul Claro"
        case .darkPurple:
            return "Roxo Escuro"
        case .lightPurple:
            return "Roxo Claro"
        case .pink:
            return "Rosa"
        case .otherPink:
            return "Salmão"
        case .beigeBrown:
            return "Bege"
        case .gray:
            return "Cinza"
        case .darkBlue:
            return "Azul Escuro"
        }
    }
}
