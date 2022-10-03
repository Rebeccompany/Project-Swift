//
//  SessionRepositoryProtocol.swift
//  
//
//  Created by Nathalia do Valle Papst on 03/10/22.
//

import Foundation
import Combine
import Models

public protocol SessionRepositoryProtocol: AnyObject {
    func object(forKey: String) -> Any?
    func string(forKey: String) -> String?
    func set(_ value: Any?, forKey: String)
}
