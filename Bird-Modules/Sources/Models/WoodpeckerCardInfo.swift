//
//  File.swift
//  
//
//  Created by Marcos Chevis on 18/08/22.
//

import Foundation

/// Card information used in woodpeckers spaced repetion algorithms
public struct WoodpeckerCardInfo: Equatable {
    
    /// indicates the step (box) the card is in the learning stage.
    public var step: Int = 0
    /// indicates if the card has graduated fom the learning stage to te reviewing stage.
    public var isGraduated: Bool = false
    // is the value calculated for how easy a card is. Should never be lower than 1.3
    public var easeFactor: Double = 2.5
    /// indicates how many times the user has correctly answered a card in the reviewing stage.
    public var streak: Int = 0
    /// indicates the interval in days that a card should appear.
    public var interval: Int = 0
    
    public init(step: Int = 0, isGraduated: Bool = false, easeFactor: Double = 2.5, streak: Int = 0, interval: Int = 0) {
        self.step = step
        self.isGraduated = isGraduated
        self.easeFactor = easeFactor
        self.streak = streak
        self.interval = interval
    }
}
