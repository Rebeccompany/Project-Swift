//
//  DateHandlerMock.swift
//  
//
//  Created by Rebecca Mello on 08/09/22.
//

import Foundation

public class DateHandlerMock: DateHandlerProtocol {
    public init() {}
    
    public var today: Date {
        Date(timeIntervalSince1970: 0)
    }
    
    public func isToday(date: Date) -> Bool {
        date == today
    }
    
    
}
