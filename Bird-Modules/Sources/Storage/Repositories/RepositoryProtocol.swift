//
//  RepositoryProtocol.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Foundation
import Combine
import CoreData

protocol RepositoryProtocol {
    associatedtype Model
    associatedtype Entity: NSManagedObject
    
    
    
    func fetchAll() -> AnyPublisher<[Model], RepositoryError>
    func listener() throws -> AnyPublisher<[Model], RepositoryError>
    func fetchById(_ id: UUID) -> AnyPublisher<Model, RepositoryError>
    func fetchMultipleById(_ ids: [UUID]) -> AnyPublisher<[Model], RepositoryError>
    func create(_ value: Model) throws
    func edit(_ value: Model) throws
    func delete(_ value: Model) throws
}

public enum RepositoryError: Error {
    case failedFetching
    case errorOnListening
    case notFound
    case couldNotEdit
    case couldNotDelete
    case internalError
    case couldNotCreate
}
