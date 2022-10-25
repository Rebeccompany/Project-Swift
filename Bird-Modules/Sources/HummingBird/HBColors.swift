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
        Color("CollectionRed", bundle: .module)
//        Color(
//            light: "#F44731",
//            dark: "#E54934")
    }
    
    static var collectionOrange: Color {
        Color("CollectionOrange", bundle: .module)
//        Color(
//            light: "#F47225",
//            dark: "#E26F1D")
    }
    
    public static var collectionYellow: Color {
        Color("CollectionYellow", bundle: .module)
//        Color(
//            light: "#F2A40D",
//            dark: "#E4A834")
    }
    
    public static var collectionGreen: Color {
        Color("CollectionGreen", bundle: .module)
//        Color(
//            light: "#0F995D",
//            dark: "#16A667")
    }
    
    public static var collectionLightBlue: Color {
        Color("CollectionLightBlue", bundle: .module)
//        Color(
//            light: "#0B9FDA",
//            dark: "#1CA2D9")
    }
    
    public static var collectionDarkPurple: Color {
        Color("CollectionDarkPurple", bundle: .module)
//        Color(
//            light: "#944FF6",
//            dark: "#9D57FF")
    }
    
    public static var collectionLightPurple: Color {
        Color("CollectionLightPurple", bundle: .module)
//        Color(
//            light: "#B36BF0",
//            dark: "#B778ED")
    }
    
    public static var collectionPink: Color {
        Color("CollectionPink", bundle: .module)
//        Color(
//            light: "#E550B5",
//            dark: "#DB58AB")
    }
    
    public static var collectionOtherPink: Color {
        Color("CollectionOtherPink", bundle: .module)
//        Color(
//            light: "#DA2C6A",
//            dark: "#E53977")
    }
    
    public static var collectionBeigeBrown: Color {
        Color("CollectionBeigeBrown", bundle: .module)
//        Color(
//            light: "#9E5615",
//            dark: "#C2654E")
    }
    
    public static var collectionGray: Color {
        Color("CollectionGray", bundle: .module)
//        Color(
//            light: "#8C8C8C",
//            dark: "#999999"
//        )
    }
    
    public static var collectionDarkBlue: Color {
        Color("CollectionDarkBlue", bundle: .module)
//        Color(
//            light: "#3D66F5",
//            dark: "#5074F7"
//        )
    }
    
    public static var actionColor: Color {
        Color("ActionColor", bundle: .module)
//        Color(
//            light: "#1394F7",
//            dark: "#21B3C9"
//        )
    }
    
    public static var secondaryPurpleColor: Color {
        Color("SecondaryPurple", bundle: .module)
//        Color(
//            light: "#4C3DF5",
//            dark: "#7A6EF7"
//        )
    }
    
    public static var secondaryOrangeYellowColor: Color {
        Color("secondaryOrangeYellow", bundle: .module)
//        Color(
//            light: "#FE4C0E",
//            dark: "#FEE440"
//        )
    }
    
    public static var secondaryGreenColor: Color {
        Color("SecondaryGreen", bundle: .module)
//        Color(
//            light: "#05A287",
//            dark: "#B4E40E"
//        )
    }
    
    public static var veryHardColor: Color {
        Color("VeryHard", bundle: .module)
//        Color(
//            light: "#FF6961",
//            dark: "#FF6961"
//        )
    }

    public static var hardColor: Color {
        Color("Hard", bundle: .module)
//        Color(
//            light: "#FFB340",
//            dark: "#FFB340"
//        )
    }
    
    public static var easyColor: Color {
        Color("Easy", bundle: .module)
//        Color(
//            light: "#409CFF",
//            dark: "#409CFF"
//        )
    }
    
    public static var veryEasyColor: Color {
        Color("VeryEasy", bundle: .module)
        
//        Color(
//            light: "#30DB5B",
//            dark: "#30DB5B"
//        )
    }
    
    public static var primaryBackground: Color {
        Color("PrimaryBackground", bundle: .module)
//        Color(
//            light: "#F2F2F7",
//            dark: "#121212"
//        )
    }
    
    public static var secondaryBackground: Color {
        Color("SecondaryBackground", bundle: .module)
//        Color(
//            light: "#FEFEFE",
//            dark: "#222222"
//        )
    }
    
    public static var shadowColor: Color {
        Color("Shadow", bundle: .module)
//        Color(
//            light: "00000038",
//            dark: "FFFFFF38"
//        )
    }
    
    public static var collectionTextColor: Color {
        Color("CollectionTextColor", bundle: .module)
//        Color(
//            light: "000000",
//            dark: "FFFFFF"
//        )
    }
    
    public static var selectIconBackground: Color {
        Color("SelectIconBackground", bundle: .module)
//        Color(
//            light: "F4F4F4",
//            dark: "121212"
//        )
    }
    
    public static var selectIconGridColor: Color {
        Color("SelectIconGridColor", bundle: .module)
//        Color(
//            light: "FFFFFF",
//            dark: "222222"
//        )
    }
    
    public static var disabledStudyButtonBackground: Color {
        Color("DisabledStudyButtonBackground", bundle: .module)
//        Color(
//            light: "FFFFFF",
//            dark: "000000"
//        )
    }
    
    public static var disabledStudyButtonForeground: Color {
        Color("DisabledStudyButtonForeground", bundle: .module)
//        Color(
//            light: "8C8C8C",
//            dark: "959595"
//        )
    }
    
    public static var intenseButtonBackground: Color {
        Color("IntenseButtonBackground", bundle: .module)
//        Color(
//            light: "F2F2F7",
//            dark: "222222"
//        )
    }
    
    public static var black: Color {
        Color.black
    }
    
    public static var white: Color {
        Color.white
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
