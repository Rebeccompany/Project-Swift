//
//  DateLogs.swift
//  
//
//  Created by Caroline Taus on 19/08/22.
//

import Foundation

/// Log of the dates of subjects.
public struct DateLogs: Equatable, Hashable, Codable {
    /// Date of the last time a subject was accessed.
    public var lastAccess: Date
    /// Date of the last time a subject was edited.
    public var lastEdit: Date
    //// Date of creation of the subject.
    public let createdAt: Date
    
    public init(lastAccess: Date = Date(), lastEdit: Date = Date(), createdAt: Date = Date()) {
        self.lastAccess = lastAccess
        self.lastEdit = lastEdit
        self.createdAt = createdAt
    }
}
