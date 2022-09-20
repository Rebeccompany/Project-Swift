//
//  CardEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Marcos Chevis on 20/09/22.
//
//

import Foundation
import CoreData

extension CardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardEntity> {
        return NSFetchRequest<CardEntity>(entityName: "CardEntity")
    }

    @NSManaged public var back: Data?
    @NSManaged public var color: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var front: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var lastAccess: Date?
    @NSManaged public var lastEdit: Date?
    @NSManaged public var wpEaseFactor: Double
    @NSManaged public var wpHasBeenPresented: Bool
    @NSManaged public var wpInterval: Int32
    @NSManaged public var wpIsGraduated: Bool
    @NSManaged public var wpStep: Int32
    @NSManaged public var wpStreak: Int32
    @NSManaged public var deck: DeckEntity?
    @NSManaged public var history: NSSet?

}

// MARK: Generated accessors for history
extension CardEntity {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: CardSnapshotEntity)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: CardSnapshotEntity)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}
