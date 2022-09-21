//
//  CardSnapshotEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Marcos Chevis on 20/09/22.
//
//

import Foundation
import CoreData

extension CardSnapshotEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardSnapshotEntity> {
        NSFetchRequest<CardSnapshotEntity>(entityName: "CardSnapshotEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var easeFactor: Double
    @NSManaged public var hasBeenPresented: Bool
    @NSManaged public var interval: Int32
    @NSManaged public var isGraduated: Bool
    @NSManaged public var step: Int32
    @NSManaged public var streak: Int32
    @NSManaged public var timeSpend: Double
    @NSManaged public var userGrade: Int32
    @NSManaged public var card: CardEntity?

}
