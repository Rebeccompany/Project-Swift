//
//  ViewBackgroundColor.swift
//  
//
//  Created by Nathalia do Valle Papst on 05/09/22.
//

import Foundation
import SwiftUI

// swiftlint:disable no_extension_access_modifier
public extension View {
    @ViewBuilder func ViewBackgroundColor(_ color: Color) -> some View {
        ZStack {
            color.ignoresSafeArea()
            self
        }
    }
}
