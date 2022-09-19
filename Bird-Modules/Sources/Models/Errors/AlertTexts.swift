//
//  File.swift
//  
//
//  Created by Rebecca Mello on 16/09/22.
//

import Foundation

public enum AlertText {
    case deleteCard
    case editCard
    case saveStudy
    case gradeCard
    
    public var texts: (title: String, message: String) {
        switch self {
        case .deleteCard:
            return ("Erro ao apagar flashcard", "Algo deu errado! Por favor, tente novamente.")
        case .editCard:
            return ("Erro ao editar flashcard", "Algo deu errado! Por favor, tente novamente.")
        case .saveStudy:
            return ("Erro ao salvar o progresso", "Algo deu errado! Por favor, tente novamente.")
        case .gradeCard:
            return ("Erro ao salvar o progresso", "Algo deu errado! Por favor, tente novamente.")
            
        }
    }
}
