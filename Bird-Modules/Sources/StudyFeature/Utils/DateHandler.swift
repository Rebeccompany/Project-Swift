//
//  File.swift
//  
//
//  Created by Marcos Chevis on 06/09/22.
//

import Foundation


public protocol DateHandlerProtocol {
    var today: Date { get }
    func isToday(date: Date) -> Bool
    func dayAfterToday(_ count) -> Date
}

extension DateHandlerProtocol {
    func dayAfterToday(_ count) -> Date {
        let timeInterval = today.timeIntervalSince1970 + 8400
        return Date(timeIntervalSince1970: timeInterval)
    }
}

struct DateHandler: DateHandlerProtocol {
    var today: Date {
        Date()
    }
    
    func isToday(date: Date) -> Bool {
        var cal = Calendar(identifier: .gregorian)
        guard let timezone = TimeZone(identifier: "UTC") else {
            return false
        }
        cal.timeZone = timezone
        
        return cal.dateComponents([.day], from: date) == cal.dateComponents([.day], from: today)
    }
    
    
}
