//
//  Deck.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A deck of flashcards.
public struct Deck: Identifiable, Equatable, Hashable {
    public let id: UUID
    /// The name of the deck.
    public var name: String
    /// The icon of a deck, an SFSymbol.
    public var icon: String
    /// The color of the deck
    public var color: CollectionColor
    /// Logs of dates.
    public var datesLogs: DateLogs
    /// A list of collection ids the deck belongs to.
    public var collectionsIds: [UUID]
    /// A list of flashcard ids the deck contains
    public var cardsIds: [UUID]
    /// Configurantion for Spaced repetition.
    public var spacedRepetitionConfig: SpacedRepetitionConfig
    
    public var cardCount: Int {
        cardsIds.count
    }
    
    public init(id: UUID, name: String, icon: String, color: CollectionColor, datesLogs: DateLogs = DateLogs(), collectionsIds: [UUID], cardsIds: [UUID], spacedRepetitionConfig: SpacedRepetitionConfig = SpacedRepetitionConfig()) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.datesLogs = datesLogs
        self.collectionsIds = collectionsIds
        self.cardsIds = cardsIds
        self.spacedRepetitionConfig = spacedRepetitionConfig
    }
}
