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
    }
    
    static var collectionOrange: Color {
        Color("CollectionOrange", bundle: .module)
    }
    
    public static var collectionYellow: Color {
        Color("CollectionYellow", bundle: .module)
    }
    
    public static var collectionGreen: Color {
        Color("CollectionGreen", bundle: .module)
    }
    
    public static var collectionLightBlue: Color {
        Color("CollectionLightBlue", bundle: .module)
    }
    
    public static var collectionDarkPurple: Color {
        Color("CollectionDarkPurple", bundle: .module)
    }
    
    public static var collectionLightPurple: Color {
        Color("CollectionLightPurple", bundle: .module)
    }
    
    public static var collectionPink: Color {
        Color("CollectionPink", bundle: .module)
    }
    
    public static var collectionOtherPink: Color {
        Color("CollectionOtherPink", bundle: .module)
    }
    
    public static var collectionBeigeBrown: Color {
        Color("CollectionBeigeBrown", bundle: .module)
    }
    
    public static var collectionGray: Color {
        Color("CollectionGray", bundle: .module)
    }
    
    public static var collectionDarkBlue: Color {
        Color("CollectionDarkBlue", bundle: .module)
    }
    
    public static var actionColor: Color {
        Color("ActionColor", bundle: .module)
    }
    
    public static var secondaryPurpleColor: Color {
        Color("SecondaryPurple", bundle: .module)
    }
    
    public static var secondaryOrangeYellowColor: Color {
        Color("secondaryOrangeYellow", bundle: .module)
    }
    
    public static var secondaryGreenColor: Color {
        Color("SecondaryGreen", bundle: .module)
    }
    
    public static var veryHardColor: Color {
        Color("VeryHard", bundle: .module)
    }

    public static var hardColor: Color {
        Color("Hard", bundle: .module)
    }
    
    public static var easyColor: Color {
        Color("Easy", bundle: .module)
    }
    
    public static var veryEasyColor: Color {
        Color("VeryEasy", bundle: .module)
    }
    
    public static var primaryBackground: Color {
        Color("PrimaryBackground", bundle: .module)
    }
    
    public static var secondaryBackground: Color {
        Color("SecondaryBackground", bundle: .module)
    }
    
    public static var shadowColor: Color {
        Color("Shadow", bundle: .module)
    }
    
    public static var collectionTextColor: Color {
        Color("CollectionTextColor", bundle: .module)
    }
    
    public static var selectIconBackground: Color {
        Color("SelectIconBackground", bundle: .module)
    }
    
    public static var selectIconGridColor: Color {
        Color("SelectIconGridColor", bundle: .module)
    }
    
    public static var disabledStudyButtonBackground: Color {
        Color("DisabledStudyButtonBackground", bundle: .module)
    }
    
    public static var disabledStudyButtonForeground: Color {
        Color("DisabledStudyButtonForeground", bundle: .module)
    }
    
    public static var intenseButtonBackground: Color {
        Color("IntenseButtonBackground", bundle: .module)
    }
    
    public static var black: Color {
        Color.black
    }
    
    public static var white: Color {
        Color.white
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
