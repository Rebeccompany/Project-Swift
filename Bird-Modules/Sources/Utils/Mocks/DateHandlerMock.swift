//
//  DateHandlerMock.swift
//  
//
//  Created by Rebecca Mello on 08/09/22.
//

import Foundation

public class DateHandlerMock: DateHandlerProtocol {
    public var customToday: Date?
    
    public init() {}
    
    public var today: Date {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone.gmt
        let secondsFomGMT = cal.timeZone.secondsFromGMT()
        let jan1stCurrent = Double(secondsFomGMT)
        return customToday ?? Date(timeIntervalSince1970: jan1stCurrent)
    }
    
    public func isToday(date: Date) -> Bool {
        date == today
    }
    
    
}
