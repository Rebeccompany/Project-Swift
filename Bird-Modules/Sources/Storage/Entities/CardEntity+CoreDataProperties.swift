//
//  CardEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Gabriel Ferreira de Carvalho on 22/11/22.
//
//

import Foundation
import CoreData

extension CardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardEntity> {
        NSFetchRequest<CardEntity>(entityName: "CardEntity")
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
    @NSManaged public var sessions: NSSet?

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

// MARK: Generated accessors for sessions
extension CardEntity {

    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: SessionEntity)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: SessionEntity)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSSet)

}
