//
//  SpacedRepetitionConfigEntity+CoreDataProperties.swift
//  Project-Bird
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//
//

import Foundation
import CoreData


extension SpacedRepetitionConfigEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpacedRepetitionConfigEntity> {
        return NSFetchRequest<SpacedRepetitionConfigEntity>(entityName: "SpacedRepetitionConfigEntity")
    }

    @NSManaged public var maxLearningCards: Int32
    @NSManaged public var maxReviewingCards: Int32
    @NSManaged public var deck: DeckEntity?

}
