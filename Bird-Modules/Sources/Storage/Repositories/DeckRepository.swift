//
//  DeckRepository.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 29/08/22.
//

import Foundation
import Combine
import Models

public protocol DeckRepository {
    func fetchDeckById(_ id: UUID) -> AnyPublisher<Card, RepositoryError>
    func fetchDeckByMultipleIds(_ ids: [UUID]) -> AnyPublisher<[Card], RepositoryError>
}
