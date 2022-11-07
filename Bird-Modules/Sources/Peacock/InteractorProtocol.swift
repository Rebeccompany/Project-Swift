//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 07/11/22.
//

import Foundation
import Combine

public protocol Interactor: ObservableObject {
    associatedtype Action
    associatedtype State
    associatedtype Store: ObservableObject
    
    func send(_ action: Action)
    func bind(to store: Store)
    func reduce( _ currentState: inout State, action: Action) -> AnyPublisher<State, Error>
}
