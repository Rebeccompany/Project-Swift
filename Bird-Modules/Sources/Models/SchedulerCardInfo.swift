//
//  SchedulerCardInfo.swift
//  
//
//  Created by Marcos Chevis on 22/08/22.
//

import Foundation

public struct SchedulerCardInfo {

    public var cardId: UUID
    public var woodpeckerCardInfo: WoodpeckerCardInfo
    public var dueDate: Date?
    
    public init(cardId: UUID, woodpeckerCardInfo: WoodpeckerCardInfo, dueDate: Date?) {
        self.cardId = cardId
        self.woodpeckerCardInfo = woodpeckerCardInfo
        self.dueDate = dueDate
    }
}
