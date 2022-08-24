//
//  DeckEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Gabriel Ferreira de Carvalho on 23/08/22.
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
    @NSManaged public var maxLearningCards: Int32
    @NSManaged public var maxReviewingCards: Int32
    @NSManaged public var cards: NSSet?
    @NSManaged public var collections: NSSet?

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
