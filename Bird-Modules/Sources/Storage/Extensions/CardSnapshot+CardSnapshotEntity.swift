//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/08/22.
//

import CoreData
import Models

extension CardSnapshot {
    init?(entity: CardSnapshotEntity) {
        guard
            let date = entity.date,
            let userGrade = UserGrade(rawValue: Int(entity.userGrade))
        else { return nil }
        
        let wpInfo = WoodpeckerCardInfo(step: Int(entity.step),
                                        isGraduated: entity.isGraduated,
                                        easeFactor: entity.easeFactor,
                                        streak: Int(entity.streak),
                                        interval: Int(entity.interval),
                                        hasBeenPresented: entity.hasBeenPresented)
        
        self.init(woodpeckerCardInfo: wpInfo,
                  userGrade: userGrade,
                  timeSpend: entity.timeSpend,
                  date: date)
    }
}

extension CardSnapshotEntity {
    convenience init(with snapshot: CardSnapshot, on context: NSManagedObjectContext) {
        self.init(context: context)
        self.date = snapshot.date
        self.timeSpend = snapshot.timeSpend
        self.userGrade = Int32(snapshot.userGrade.rawValue)
        self.streak = Int32(snapshot.woodpeckerCardInfo.streak)
        self.easeFactor = snapshot.woodpeckerCardInfo.easeFactor
        self.isGraduated = snapshot.woodpeckerCardInfo.isGraduated
        self.interval = Int32(snapshot.woodpeckerCardInfo.interval)
    }
}
