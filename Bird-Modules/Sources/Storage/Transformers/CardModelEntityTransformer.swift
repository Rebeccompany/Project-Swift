//
//  CardModelEntityTransformer.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import Models
import CoreData
import Utils

import SwiftUI

struct CardModelEntityTransformer: ModelEntityTransformer {
    
    func requestForAll() -> NSFetchRequest<CardEntity> {
        let request = CardEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardEntity.wpStep, ascending: true)]
        return request
    }
    
    func listenerRequest() -> NSFetchRequest<CardEntity> {
        requestForAll()
    }
    
    func entityToModel(_ entity: CardEntity) -> Card? {
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
            let snapshotsEntities = entity.history?.allObjects as? [CardSnapshotEntity]
        else { return nil }
        
        let easeFactor = entity.wpEaseFactor
        let isGraduated = entity.wpIsGraduated
        let interval = entity.wpInterval
        let step = entity.wpStep
        let streak = entity.wpStreak
        let wpData = WoodpeckerCardInfo(step: Int(step), isGraduated: isGraduated, easeFactor: easeFactor, streak: Int(streak), interval: Int(interval), hasBeenPresented: entity.wpHasBeenPresented)
        let dateLog = DateLogs(lastAccess: lastAccess, lastEdit: lastEdit, createdAt: createdAt)
        let history = snapshotsEntities.compactMap(CardSnapshot.init)
        
        return Card(id: id,
                    front: AttributedString(frontNSAttributedString),
                    back: AttributedString(backNSAttributedString),
                    color: CollectionColor(rawValue: Int(entity.color)) ?? .red,
                    datesLogs: dateLog,
                    deckID: deckId,
                    woodpeckerCardInfo: wpData,
                    history: history)
    }
    
    func modelToEntity(_ model: Card, on context: NSManagedObjectContext) -> CardEntity {
        let card = CardEntity(context: context)
        
        card.front = NSAttributedString(model.front).rtfData()
        card.back = NSAttributedString(model.back).rtfData()
        card.createdAt = model.datesLogs.createdAt
        card.lastEdit = model.datesLogs.lastEdit
        card.lastAccess = model.datesLogs.lastAccess
        card.color = Int16(model.color.rawValue)
        card.id = model.id
        card.wpStep = Int32(model.woodpeckerCardInfo.step)
        card.wpStreak = Int32(model.woodpeckerCardInfo.streak)
        card.wpInterval = Int32(model.woodpeckerCardInfo.interval)
        card.wpEaseFactor = model.woodpeckerCardInfo.easeFactor
        card.wpIsGraduated = model.woodpeckerCardInfo.isGraduated
        card.wpHasBeenPresented = model.woodpeckerCardInfo.hasBeenPresented
        return card
    }
}
