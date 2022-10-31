//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 31/10/22.
//

import Foundation

public struct NewFlashcardWindowData: Equatable, Hashable, Codable {
    public var deckId: UUID
    public var editingFlashcardId: UUID?
    
    public init(deckId: UUID, editingFlashcardId: UUID? = nil) {
        self.deckId = deckId
        self.editingFlashcardId = editingFlashcardId
    }
}
