//
//  DeckCategory.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import Foundation
 
public enum DeckCategory: String, Codable {
    case languages
    case stem
    case humanities
    case arts
    case medicine
    case law
    case others
}

public func getCategoryString(category: DeckCategory) -> String {
    switch category {
    case .languages:
        return NSLocalizedString("idiomas", bundle: .module, comment: "")
    case .stem:
        return NSLocalizedString("exatas", bundle: .module, comment: "")
    case .humanities:
        return NSLocalizedString("humanas", bundle: .module, comment: "")
    case .arts:
        return NSLocalizedString("artes", bundle: .module, comment: "")
    case .medicine:
        return NSLocalizedString("medicina", bundle: .module, comment: "")
    case .law:
        return NSLocalizedString("direito", bundle: .module, comment: "")
    case .others:
        return NSLocalizedString("outros", bundle: .module, comment: "")
    }
}
