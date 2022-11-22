//
//  DeckCategory.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import Foundation
import SwiftUI
public enum DeckCategory: String, Codable, CaseIterable {
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

@ViewBuilder
public func getCategoryLabel(category: DeckCategory) -> some View {
    switch category {
    case .languages:
        Label(getCategoryString(category: category), systemImage: "abc")
    case .stem:
        Label(getCategoryString(category: category), systemImage: "testtube.2")
    case .humanities:
        Label(getCategoryString(category: category), systemImage: "globe.desk")
    case .arts:
        Label(getCategoryString(category: category), systemImage: "theatermask.and.paintbrush")
    case .medicine:
        Label(getCategoryString(category: category), systemImage: "stethoscope")
    case .law:
        Label(getCategoryString(category: category), systemImage: "text.book.closed")
    case .others:
        Label(getCategoryString(category: category), systemImage: "tag")
    }
}

/*
 Lang abc
 Stem testtube.2
 Humanities globe.desk
 Law text.book.closed
 Medicine stethoscope
 Arts theatermask.and.paintbrush
 Other tag
 */
