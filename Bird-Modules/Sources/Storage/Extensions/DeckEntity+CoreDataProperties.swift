//
//  DeckEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//
//

import Foundation
import CoreData


extension DeckEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeckEntity> {
        return NSFetchRequest<DeckEntity>(entityName: "DeckEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastAccess: Date?
    @NSManaged public var lastEdit: Date?
    @NSManaged public var name: String?
    @NSManaged public var cards: NSSet?
    @NSManaged public var collections: NSSet?
    @NSManaged public var spacedRepetitionConfigs: NSOrderedSet?

}

// MARK: Generated accessors for cards
extension DeckEntity {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CardEntity)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CardEntity)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

// MARK: Generated accessors for collections
extension DeckEntity {

    @objc(addCollectionsObject:)
    @NSManaged public func addToCollections(_ value: CollectionEntity)

    @objc(removeCollectionsObject:)
    @NSManaged public func removeFromCollections(_ value: CollectionEntity)

    @objc(addCollections:)
    @NSManaged public func addToCollections(_ values: NSSet)

    @objc(removeCollections:)
    @NSManaged public func removeFromCollections(_ values: NSSet)

}

// MARK: Generated accessors for spacedRepetitionConfigs
extension DeckEntity {

    @objc(insertObject:inSpacedRepetitionConfigsAtIndex:)
    @NSManaged public func insertIntoSpacedRepetitionConfigs(_ value: SpacedRepetitionConfigEntity, at idx: Int)

    @objc(removeObjectFromSpacedRepetitionConfigsAtIndex:)
    @NSManaged public func removeFromSpacedRepetitionConfigs(at idx: Int)

    @objc(insertSpacedRepetitionConfigs:atIndexes:)
    @NSManaged public func insertIntoSpacedRepetitionConfigs(_ values: [SpacedRepetitionConfigEntity], at indexes: NSIndexSet)

    @objc(removeSpacedRepetitionConfigsAtIndexes:)
    @NSManaged public func removeFromSpacedRepetitionConfigs(at indexes: NSIndexSet)

    @objc(replaceObjectInSpacedRepetitionConfigsAtIndex:withObject:)
    @NSManaged public func replaceSpacedRepetitionConfigs(at idx: Int, with value: SpacedRepetitionConfigEntity)

    @objc(replaceSpacedRepetitionConfigsAtIndexes:withSpacedRepetitionConfigs:)
    @NSManaged public func replaceSpacedRepetitionConfigs(at indexes: NSIndexSet, with values: [SpacedRepetitionConfigEntity])

    @objc(addSpacedRepetitionConfigsObject:)
    @NSManaged public func addToSpacedRepetitionConfigs(_ value: SpacedRepetitionConfigEntity)

    @objc(removeSpacedRepetitionConfigsObject:)
    @NSManaged public func removeFromSpacedRepetitionConfigs(_ value: SpacedRepetitionConfigEntity)

    @objc(addSpacedRepetitionConfigs:)
    @NSManaged public func addToSpacedRepetitionConfigs(_ values: NSOrderedSet)

    @objc(removeSpacedRepetitionConfigs:)
    @NSManaged public func removeFromSpacedRepetitionConfigs(_ values: NSOrderedSet)

}
