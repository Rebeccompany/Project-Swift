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
    func listener() -> AnyPublisher<[T], RepositoryError>
    func fetchById() -> AnyPublisher<T, RepositoryError>
    func create(_ value: T) -> AnyPublisher<Void, RepositoryError>
    func edit(_ value: T) -> AnyPublisher<Void, RepositoryError>
    func delete(_ value: T) -> AnyPublisher<Void, RepositoryError>
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
