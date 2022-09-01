//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 01/09/22.
//

import Foundation
import SwiftUI

struct HBColor {
    var light: Color
    var dark: Color
    
    func color(for scheme: ColorScheme) -> Color {
        switch scheme {
        case .light:
            return light
        case .dark:
            return dark
        @unknown default:
            return light
        }
    }
}

extension HBColor {
    static var collectionRed: HBColor {
        HBColor(
            light: Color(hex: "#DC443B") ?? .red,
            dark: Color(hex: "#DC4833") ?? .red
        )
    }
    
    static var collectionOrange: HBColor {
        HBColor(
            light: Color(hex: "#F37012") ?? .orange,
            dark: Color(hex: "#FF934F") ?? .red)
    }
}
