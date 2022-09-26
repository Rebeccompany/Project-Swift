//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//

import SwiftUI

public struct HabitatPreview<V: View>: View {
    var child: () -> V
    
    init(@ViewBuilder child: @escaping () -> V) {
        setupHabitatForIsolatedTesting()
        self.child = child
    }
    
    public var body: some View {
        child()
    }
}
