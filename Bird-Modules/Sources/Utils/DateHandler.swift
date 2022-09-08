//
//  DateHandler.swift
//
//
//  Created by Marcos Chevis on 06/09/22.
//
import Foundation


public protocol DateHandlerProtocol {
    var today: Date { get }
    func isToday(date: Date) -> Bool
    func dayAfterToday(_ count: Int) -> Date
}
// swiftlint:disable no_extension_access_modifier
public extension DateHandlerProtocol {
    func dayAfterToday(_ count: Int) -> Date {
        let timeInterval = today.timeIntervalSince1970 + Double(8400 * count)
        return Date(timeIntervalSince1970: timeInterval)
    }
}

public struct DateHandler: DateHandlerProtocol {
    public init() {}
    
    public var today: Date {
        Date()
    }
    
    public func isToday(date: Date) -> Bool {
        var cal = Calendar(identifier: .gregorian)
        guard let timezone = TimeZone(identifier: "UTC") else {
            return false
        }
        cal.timeZone = timezone
        
        return cal.dateComponents([.day], from: date) == cal.dateComponents([.day], from: today)
    }
}
    
