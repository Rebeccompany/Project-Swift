//
//  DateHandlerMock.swift
//  
//
//  Created by Rebecca Mello on 08/09/22.
//

import Foundation
import Utils

struct DateHandlerMock: DateHandlerProtocol {
    var today: Date {
        return Date(timeIntervalSince1970: 0)
    }
    
    func isToday(date: Date) -> Bool {
        date == today
    }
    
    
}
