//
//  RepositoryProtocol.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 22/08/22.
//

import Foundation
import Combine

public protocol RepositoryProtocol {
    associatedtype T
    
    func fetchAll() -> AnyPublisher<[T], RepositoryError>
    func listener() throws -> AnyPublisher<[T], RepositoryError>
    func fetchById(_ id: UUID) -> AnyPublisher<T, RepositoryError>
    func fetchMultipleById(_ ids: [UUID]) -> AnyPublisher<[T], RepositoryError>
    func create(_ value: T) throws
    func edit(_ value: T) throws
    func delete(_ value: T) throws
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
