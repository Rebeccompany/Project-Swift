//
//  File.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
//

import Foundation
import SwiftUI

public enum IconNames: String, CaseIterable {
    case pencil
    case book
    case chevronDown
    
    public static func getIconString(_ iconName: IconNames) -> String {
        switch iconName {
        case .pencil:
            return "pencil"
        case .book:
            return "book"
        case .chevronDown:
            return "chevron.down"
        }
    }
}
