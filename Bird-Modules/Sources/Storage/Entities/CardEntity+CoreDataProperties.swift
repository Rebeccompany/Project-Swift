//
//  CardEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Gabriel Ferreira de Carvalho on 23/08/22.
//
//

import Foundation
import CoreData
import Storage

extension CardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardEntity> {
        return NSFetchRequest<CardEntity>(entityName: "CardEntity")
    }

    @NSManaged public var back: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var front: Data?
    @NSManaged public var id: UUID?
    @NSManaged public var lastAccess: Date?
    @NSManaged public var lastEdit: Date?
    @NSManaged public var wpEaseFactor: Double
    @NSManaged public var wpInterval: Int32
    @NSManaged public var wpIsGraduated: Bool
    @NSManaged public var wpStep: Int32
    @NSManaged public var wpStreak: Int32
    @NSManaged public var deck: DeckEntity?
    @NSManaged public var history: NSOrderedSet?

}

// MARK: Generated accessors for history
extension CardEntity {

    @objc(insertObject:inHistoryAtIndex:)
    @NSManaged public func insertIntoHistory(_ value: CardSnapshotEntity, at idx: Int)

    @objc(removeObjectFromHistoryAtIndex:)
    @NSManaged public func removeFromHistory(at idx: Int)

    @objc(insertHistory:atIndexes:)
    @NSManaged public func insertIntoHistory(_ values: [CardSnapshotEntity], at indexes: NSIndexSet)

    @objc(removeHistoryAtIndexes:)
    @NSManaged public func removeFromHistory(at indexes: NSIndexSet)

    @objc(replaceObjectInHistoryAtIndex:withObject:)
    @NSManaged public func replaceHistory(at idx: Int, with value: CardSnapshotEntity)

    @objc(replaceHistoryAtIndexes:withHistory:)
    @NSManaged public func replaceHistory(at indexes: NSIndexSet, with values: [CardSnapshotEntity])

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: CardSnapshotEntity)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: CardSnapshotEntity)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSOrderedSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSOrderedSet)

}
