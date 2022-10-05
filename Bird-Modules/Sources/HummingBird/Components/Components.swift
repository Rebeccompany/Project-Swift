//
//  SwiftUIView.swift
//  
//
//  Created by Rebecca Mello on 21/09/22.
//
import SwiftUI

public enum Components {
    case collection
    case deck
    case flashcard
}

public func getComponentString(component: Components) -> String {
    switch component {
    case .collection:
        return NSLocalizedString("colecao", bundle: .module, comment: "")
    case .deck:
        return NSLocalizedString("deck", bundle: .module, comment: "")
    case .flashcard:
        return "flashcard"
    }
}
