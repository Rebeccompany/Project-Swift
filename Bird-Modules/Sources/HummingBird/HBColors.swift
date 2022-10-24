//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 01/09/22.
//

import Foundation
import SwiftUI
import Models

public enum HBColor {
    
    public static var collectionRed: Color {
        Color(
            light: "#F44731",
            dark: "#E54934")
    }
    
    static var collectionOrange: Color {
        Color(
            light: "#F47225",
            dark: "#E26F1D")
    }
    
    public static var collectionYellow: Color {
        Color(
            light: "#F2A40D",
            dark: "#E4A834")
    }
    
    public static var collectionGreen: Color {
        Color(
            light: "#0F995D",
            dark: "#16A667")
    }
    
    public static var collectionLightBlue: Color {
        Color(
            light: "#0B9FDA",
            dark: "#1CA2D9")
    }
    
    public static var collectionDarkPurple: Color {
        Color(
            light: "#944FF6",
            dark: "#9D57FF")
    }
    
    public static var collectionLightPurple: Color {
        Color(
            light: "#B36BF0",
            dark: "#B778ED")
    }
    
    public static var collectionPink: Color {
        Color(
            light: "#E550B5",
            dark: "#DB58AB")
    }
    
    public static var collectionOtherPink: Color {
        Color(
            light: "#DA2C6A",
            dark: "#E53977")
    }
    
    public static var collectionBeigeBrown: Color {
        Color(
            light: "#9E5615",
            dark: "#C2654E")
    }
    
    public static var collectionGray: Color {
        Color(
            light: "#8C8C8C",
            dark: "#999999"
        )
    }
    
    public static var collectionDarkBlue: Color {
        Color(
            light: "#3D66F5",
            dark: "#5074F7"
        )
    }
    
    public static var actionColor: Color {
        Color(
            light: "#1394F7",
            dark: "#21B3C9"
        )
    }
    
    public static var secondaryPurpleColor: Color {
        Color(
            light: "#4C3DF5",
            dark: "#7A6EF7"
        )
    }
    
    public static var secondaryOrangeYellowColor: Color {
        Color(
            light: "#FE4C0E",
            dark: "#FEE440"
        )
    }
    
    public static var secondaryGreenColor: Color {
        Color(
            light: "#05A287",
            dark: "#B4E40E"
        )
    }
    
    public static var veryHardColor: Color {
        Color(
            light: "#FF6961",
            dark: "#FF6961"
        )
    }

    public static var hardColor: Color {
        Color(
            light: "#FFB340",
            dark: "#FFB340"
        )
    }
    
    public static var easyColor: Color {
        Color(
            light: "#409CFF",
            dark: "#409CFF"
        )
    }
    
    public static var veryeasyColor: Color {
        Color(
            light: "#30DB5B",
            dark: "#30DB5B"
        )
    }
    
    public static var primaryBackground: Color {
        Color(
            light: "#F2F2F7",
            dark: "#121212"
        )
    }
    
    public static var secondaryBackground: Color {
        Color(
            light: "#FEFEFE",
            dark: "#222222"
        )
    }
    
    public static var shadowColor: Color {
        Color(
            light: "00000038",
            dark: "FFFFFF38"
        )
    }
    
    public static var collectionTextColor: Color {
        Color(
            light: "000000",
            dark: "FFFFFF"
        )
    }
    
    public static var selectIconBackground: Color {
        Color(
            light: "F4F4F4",
            dark: "121212"
        )
    }
    
    public static var selectIconGridColor: Color {
        Color(
            light: "FFFFFF",
            dark: "222222"
        )
    }
    
    public static var disabledStudyButtonBackground: Color {
        Color(
            light: "FFFFFF",
            dark: "000000"
        )
    }
    
    public static var disabledStudyButtonForeground: Color {
        Color(
            light: "8C8C8C",
            dark: "959595"
        )
    }
    
    public static var intenseButtonBackground: Color {
        Color(
            light: "F2F2F7",
            dark: "222222"
        )
    }
    
    public static var progressGraphTotalBackground: Color {
        Color(light: "E1D1EE",
              dark: "4A345E"
        )
    }
    
    public static var progressGraphTotal: Color {
        Color(light: "B36BF0",
              dark: "B778ED"
        )
    }
    
    public static var progressGraphReviewingBackground: Color {
        Color(light: "BAE0CF",
              dark: "374B42"
        )
    }
    
    public static var progressGraphReviewing: Color {
        Color(light: "08A15E",
              dark: "13925B"
        )
    }
    
    public static var progressGraphLearningBackground: Color {
        Color(light: "EED1BC",
              dark: "472E1E"
        )
    }
    
    public static var progressGraphLearning: Color {
        Color(light: "F37012",
              dark: "DB641C"
        )
    }
    
    public static var newCollectionSidebar: Color {
        Color(light: "FFFFFF99",
              dark: "00000099"
        )
    }
    

    public static func color(for collectionColor: CollectionColor) -> Color {
        switch collectionColor {
        case .red:
            return Self.collectionRed
        case .orange:
            return Self.collectionOrange
        case .yellow:
            return Self.collectionYellow
        case .green:
            return Self.collectionGreen
        case .lightBlue:
            return Self.collectionLightBlue
        case .darkPurple:
            return Self.collectionDarkPurple
        case .lightPurple:
            return Self.collectionLightPurple
        case .pink:
            return Self.collectionPink
        case .otherPink:
            return Self.collectionOtherPink
        case .beigeBrown:
            return Self.collectionBeigeBrown
        case .gray:
            return Self.collectionGray
        case .darkBlue:
            return Self.collectionDarkBlue
        
        }
    }
}
