//
//  CardSnapshotTransformer.swift
//  
//
//  Created by Marcos Chevis on 03/10/22.
//

import Foundation
import CoreData
import Models

struct CardSnapshotTransformer: ModelEntityTransformer {
    func requestForAll() -> NSFetchRequest<CardSnapshotEntity> {
        let request = CardSnapshotEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardSnapshotEntity.date, ascending: true)]
        return request
    }
    
    func listenerRequest() -> NSFetchRequest<CardSnapshotEntity> {
        requestForAll()
    }
    
    
    func modelToEntity(_ model: CardSnapshot, on context: NSManagedObjectContext) -> CardSnapshotEntity {
        let entity = CardSnapshotEntity(context: context)
        
        entity.step = Int32(model.woodpeckerCardInfo.step)
        entity.isGraduated = model.woodpeckerCardInfo.isGraduated
        entity.easeFactor = model.woodpeckerCardInfo.easeFactor
        entity.streak = Int32(model.woodpeckerCardInfo.streak)
        entity.hasBeenPresented = model.woodpeckerCardInfo.hasBeenPresented
        entity.userGrade = Int32(model.userGrade.rawValue)
        entity.timeSpend = model.timeSpend
        entity.date = model.date
        entity.interval = Int32(model.woodpeckerCardInfo.interval)
        
        return entity
    }
    
    
    func entityToModel(_ entity: CardSnapshotEntity) -> CardSnapshot? {
        
        guard let userGrade = UserGrade(rawValue: Int(entity.userGrade)),
              let date = entity.date else {
            return nil
        }
        
        return CardSnapshot(woodpeckerCardInfo: WoodpeckerCardInfo(step: Int(entity.step),
                                                                   isGraduated: entity.isGraduated,
                                                                   easeFactor: entity.easeFactor,
                                                                   streak: Int(entity.streak),
                                                                   interval: Int(entity.interval),
                                                                   hasBeenPresented: entity.hasBeenPresented),
                            userGrade: userGrade,
                            timeSpend: entity.timeSpend,
                            date: date)
        
        
        
    }
}
