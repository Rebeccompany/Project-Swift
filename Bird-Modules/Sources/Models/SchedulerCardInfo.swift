//
//  SchedulerCardInfo.swift
//  
//
//  Created by Marcos Chevis on 22/08/22.
//

import Foundation

/// Card information used in woodpecker's scheduler
public struct SchedulerCardInfo {
    public var cardId: UUID
    /// The woodpeckerCardInfo of the card.
    public var woodpeckerCardInfo: WoodpeckerCardInfo
    /// The due date for the card to appear to the user
    public var dueDate: Date?
    
    public init(cardId: UUID, woodpeckerCardInfo: WoodpeckerCardInfo, dueDate: Date?) {
        self.cardId = cardId
        self.woodpeckerCardInfo = woodpeckerCardInfo
        self.dueDate = dueDate
    }
}
