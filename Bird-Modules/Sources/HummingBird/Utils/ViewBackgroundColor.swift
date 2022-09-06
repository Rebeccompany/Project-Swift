//
//  ViewBackgroundColor.swift
//  
//
//  Created by Rebecca Mello on 06/09/22.
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
