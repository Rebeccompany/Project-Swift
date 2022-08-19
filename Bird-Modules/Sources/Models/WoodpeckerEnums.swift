//
//  WoodpeckerEnums.swift
//  
//
//  Created by Marcos Chevis on 18/08/22.
//

import Foundation

/// Enumerates the possible destinies of a card in the learning stage.
public enum CardDestiny {
    case back, stay, foward, graduate
}

// Enumerates the possible grades a user can give a card.
public enum UserGrade: Int {
    case wrongHard, wrong, correct, correctEasy
}
