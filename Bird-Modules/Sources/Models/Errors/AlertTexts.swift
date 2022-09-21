//
//  File.swift
//  
//
//  Created by Rebecca Mello on 16/09/22.
//

import Foundation

public enum AlertText {
    case createCard
    case deleteCard
    case editCard
    case createDeck
    case deleteDeck
    case editDeck
    case createCollection
    case deleteCollection
    case editCollection
    case saveStudy
    case gradeCard
    
    public var texts: (title: String, message: String) {
        switch self {
        case .createCard:
            return ("Erro ao criar flashcard", "Algo deu errado! Por favor, tente novamente.")
        case .deleteCard:
            return ("Erro ao apagar flashcard", "Algo deu errado! Por favor, tente novamente.")
        case .editCard:
            return ("Erro ao editar flashcard", "Algo deu errado! Por favor, tente novamente.")
        case .createDeck:
            return ("Erro ao criar baralho", "Algo deu errado! Por favor, tente novamente.")
        case .deleteDeck:
            return ("Erro ao apagar baralho", "Algo deu errado! Por favor, tente novamente.")
        case .editDeck:
            return ("Erro ao editar baralho", "Algo deu errado! Por favor, tente novamente.")
        case .createCollection:
            return ("Erro ao criar coleção", "Algo deu errado! Por favor, tente novamente.")
        case .deleteCollection:
            return ("Erro ao apagar coleção", "Algo deu errado! Por favor, tente novamente.")
        case .editCollection:
            return ("Erro ao editar coleção", "Algo deu errado! Por favor, tente novamente.")
        case .saveStudy:
            return ("Erro ao salvar o progresso", "Algo deu errado! Por favor, tente novamente.")
        case .gradeCard:
            return ("Erro ao salvar o progresso", "Algo deu errado! Por favor, tente novamente.")  
        }
    }
}
