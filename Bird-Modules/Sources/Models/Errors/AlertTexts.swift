//
//  File.swift
//  
//
//  Created by Rebecca Mello on 16/09/22.
//

import Foundation

public enum AlertText {
    case delete
    case edit
    
    public var texts: (title: String, message: String) {
        switch self {
        case .delete:
            return ("Erro ao apagar flashcard", "Algo deu errado! Por favor, tente novamente.")
        case .edit:
            return ("Erro ao editar flashcard", "Algo deu errado! Por favor, tente novamente.")
            
        }
    }
}
