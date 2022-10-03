//
//  CollectionEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Nathalia do Valle Papst on 03/10/22.
//
//

import Foundation
import CoreData

extension CollectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionEntity> {
        return NSFetchRequest<CollectionEntity>(entityName: "CollectionEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastAccess: Date?
    @NSManaged public var lastEdit: Date?
    @NSManaged public var name: String?
    @NSManaged public var decks: NSSet?

}

// MARK: Generated accessors for decks
extension CollectionEntity {

    @objc(addDecksObject:)
    @NSManaged public func addToDecks(_ value: DeckEntity)

    @objc(removeDecksObject:)
    @NSManaged public func removeFromDecks(_ value: DeckEntity)

    @objc(addDecks:)
    @NSManaged public func addToDecks(_ values: NSSet)

    @objc(removeDecks:)
    @NSManaged public func removeFromDecks(_ values: NSSet)

}
