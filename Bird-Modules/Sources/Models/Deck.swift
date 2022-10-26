//
//  Deck.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A deck of flashcards.
public struct Deck: Identifiable, Equatable, Hashable, Codable {
    public let id: UUID
    /// The name of the deck.
    public var name: String
    /// The icon of a deck, an SFSymbol.
    public var icon: String
    /// The color of the deck
    public var color: CollectionColor
    /// Logs of dates.
    public var datesLogs: DateLogs
    /// The collection id the deck belongs to.
    public var collectionId: UUID?
    /// A list of flashcard ids the deck contains
    public var cardsIds: [UUID]
    /// Configurantion for Spaced repetition.
    public var spacedRepetitionConfig: SpacedRepetitionConfig
    /// Current active session
    public var session: Session?
    
    public var cardCount: Int {
        cardsIds.count
    }

    public var category: DeckCategory
    
    public var storeId: String?
    
    public init(id: UUID, name: String, icon: String, color: CollectionColor, datesLogs: DateLogs = DateLogs(), collectionId: UUID?, cardsIds: [UUID], spacedRepetitionConfig: SpacedRepetitionConfig = SpacedRepetitionConfig(), session: Session? = nil, category: DeckCategory, storeId: String?) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.datesLogs = datesLogs
        self.collectionId = collectionId
        self.cardsIds = cardsIds
        self.spacedRepetitionConfig = spacedRepetitionConfig
        self.session = session
        self.category = category
        self.storeId = storeId
    }
}
