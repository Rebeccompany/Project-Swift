//
//  CollectionEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Gabriel Ferreira de Carvalho on 23/08/22.
//
//

import Foundation
import CoreData
extension CollectionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollectionEntity> {
        return NSFetchRequest<CollectionEntity>(entityName: "CollectionEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var iconPath: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastAccess: Date?
    @NSManaged public var lastEdit: Date?
    @NSManaged public var name: String?
    @NSManaged public var decks: NSOrderedSet?

}

// MARK: Generated accessors for decks
extension CollectionEntity {

    @objc(insertObject:inDecksAtIndex:)
    @NSManaged public func insertIntoDecks(_ value: DeckEntity, at idx: Int)

    @objc(removeObjectFromDecksAtIndex:)
    @NSManaged public func removeFromDecks(at idx: Int)

    @objc(insertDecks:atIndexes:)
    @NSManaged public func insertIntoDecks(_ values: [DeckEntity], at indexes: NSIndexSet)

    @objc(removeDecksAtIndexes:)
    @NSManaged public func removeFromDecks(at indexes: NSIndexSet)

    @objc(replaceObjectInDecksAtIndex:withObject:)
    @NSManaged public func replaceDecks(at idx: Int, with value: DeckEntity)

    @objc(replaceDecksAtIndexes:withDecks:)
    @NSManaged public func replaceDecks(at indexes: NSIndexSet, with values: [DeckEntity])

    @objc(addDecksObject:)
    @NSManaged public func addToDecks(_ value: DeckEntity)

    @objc(removeDecksObject:)
    @NSManaged public func removeFromDecks(_ value: DeckEntity)

    @objc(addDecks:)
    @NSManaged public func addToDecks(_ values: NSOrderedSet)

    @objc(removeDecks:)
    @NSManaged public func removeFromDecks(_ values: NSOrderedSet)

}
