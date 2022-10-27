//
//  Card.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// A flashcard.
public struct Card: Identifiable, Equatable, Hashable {
    public let id: UUID
    /// Information displayed on the front of the card.
    public var front: NSAttributedString
    /// Information displayed on the back of the card.
    public var back: NSAttributedString
    /// the color of the card
    public var color: CollectionColor
    /// Logs of dates.
    public var datesLogs: DateLogs
    /// The id of the deck the card belongs to.
    public var deckID: UUID
    /// The due date for the card to appear to the user
    public var dueDate: Date? {
        get {
            let newestItem = history.max { card0, card1 in
            card0.date > card1.date
            }
            return newestItem?.date.advanced(by: TimeInterval(86400 * woodpeckerCardInfo.interval))
        }
        set {
            guard let newValue = newValue, let newestItem = history.max(by: { card0, card1 in
            card0.date > card1.date
            }) else {
                return
            }
            let increment = Int((newValue.addingTimeInterval(-newestItem.date.timeIntervalSince1970)).timeIntervalSince1970 / 86400)
            let newInterval = woodpeckerCardInfo.interval + increment
            if newInterval < 0 {
                woodpeckerCardInfo.interval = 0
            } else {
                woodpeckerCardInfo.interval = newInterval
            }
        }
    }
    /// The woodpeckerCardInfo of the card.
    public var woodpeckerCardInfo: WoodpeckerCardInfo
    /// List of the CardSnapshots of the card.
    public var history: [CardSnapshot]
    
    public init(id: UUID, front: NSAttributedString, back: NSAttributedString, color: CollectionColor, datesLogs: DateLogs, deckID: UUID, woodpeckerCardInfo: WoodpeckerCardInfo, history: [CardSnapshot]) {
        self.id = id
        self.front = front
        self.back = back
        self.color = color
        self.datesLogs = datesLogs
        self.deckID = deckID
        self.woodpeckerCardInfo = woodpeckerCardInfo
        self.history = history
    }
}
