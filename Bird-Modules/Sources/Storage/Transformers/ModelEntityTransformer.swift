//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import CoreData

protocol ModelEntityTransformer {
    associatedtype Model
    associatedtype Entity: NSManagedObject
    
    func modelToEntity(_ model: Model, on context: NSManagedObjectContext) -> Entity
    func entityToModel(_ entity: Entity) -> Model
}
