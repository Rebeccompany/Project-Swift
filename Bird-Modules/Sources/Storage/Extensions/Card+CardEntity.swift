//
//  Card+CardEntity.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/08/22.
//
import Foundation
import SwiftUI
import Models
import CoreData

extension Card {
    init?(entity: CardEntity) {
        guard
            let frontData = entity.front,
            let frontNSAttributedString = frontData.toRtf(),
            let backData = entity.back,
            let backNSAttributedString = backData.toRtf(),
            let id = entity.id,
            let createdAt = entity.createdAt,
            let lastAccess = entity.lastAccess,
            let lastEdit = entity.lastEdit,
            let deckId = entity.deck?.id,
            let snapshotsEntities = entity.history?.array as? [CardSnapshotEntity]
        else { return nil }
        
        let easeFactor = entity.wpEaseFactor
        let isGraduated = entity.wpIsGraduated
        let interval = entity.wpInterval
        let step = entity.wpStep
        let streak = entity.wpStreak
        let wpData = WoodpeckerCardInfo(step: Int(step), isGraduated: isGraduated, easeFactor: easeFactor, streak: Int(streak), interval: Int(interval))
        let dateLog = DateLogs(lastAccess: lastAccess, lastEdit: lastEdit, createdAt: createdAt)
        let history = snapshotsEntities.compactMap(CardSnapshot.init)
        
        
        self.init(id: id,
                  front: AttributedString(frontNSAttributedString),
                  back: AttributedString(backNSAttributedString),
                  datesLogs: dateLog,
                  deckID: deckId,
                  woodpeckerCardInfo: wpData,
                  history: history)
        
    }
}

extension CardEntity {
    convenience init(with card: Card, on context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.front = NSAttributedString(card.front).rftData()
        self.back = NSAttributedString(card.back).rftData()
        self.createdAt = card.datesLogs.createdAt
        self.lastEdit = card.datesLogs.lastEdit
        self.lastAccess = card.datesLogs.lastAccess
        self.id = card.id
        self.wpStep = Int32(card.woodpeckerCardInfo.step)
        self.wpStreak = Int32(card.woodpeckerCardInfo.streak)
        self.wpInterval = Int32(card.woodpeckerCardInfo.interval)
        self.wpEaseFactor = card.woodpeckerCardInfo.easeFactor
        self.wpIsGraduated = card.woodpeckerCardInfo.isGraduated
    }
}

extension Data {
    func toRtf() -> NSAttributedString? {
        try? NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
    }
}

extension NSAttributedString {
    func rftData() -> Data? {
        try? data(from: .init(location: 0, length: length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
    }
}
