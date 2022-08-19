//
//  File.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A deck of flashcards.
public struct Deck {
    public let id: UUID
    /// The name of the deck.
    public var name: String
    /// The icon of a deck, an emoji.
    public var icon: Character
    /// Logs of dates.
    public var datesLogs: [DateLogs]
    /// A list of collection ids the deck belongs to.
    public var collectionsIds: [UUID]
    /// A list of flashcard ids the deck contains
    public var cardsIds: [UUID]
    /// Configurantion for Spaced repetition.
    public var spacedRepetitionConfig: [SpacedRepetitionConfig]
    
    public init(id: UUID, name: String, icon: Character, datesLogs: [DateLogs], collectionsIds: [UUID], cardsIds: [UUID], spacedRepetitionConfig: [SpacedRepetitionConfig]) {
        self.id = id
        self.name = name
        self.icon = icon
        self.datesLogs = datesLogs
        self.collectionsIds = collectionsIds
        self.cardsIds = cardsIds
        self.spacedRepetitionConfig = spacedRepetitionConfig
    }
}
