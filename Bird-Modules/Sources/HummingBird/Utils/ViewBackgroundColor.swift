//
//  ViewBackgroundColor.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import Foundation
import SwiftUI

public extension View {
    @ViewBuilder func ViewBackgroundColor(_ color: Color) -> some View {
        ZStack {
            color.ignoresSafeArea()
            self
        }
    }
}
