//
//  SessionEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Rebecca Mello on 25/10/22.
//
//

import Foundation
import CoreData

extension SessionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SessionEntity> {
        NSFetchRequest<SessionEntity>(entityName: "SessionEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var cards: NSSet?
    @NSManaged public var deck: DeckEntity?

}

// MARK: Generated accessors for cards
extension SessionEntity {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: CardEntity)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: CardEntity)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}
