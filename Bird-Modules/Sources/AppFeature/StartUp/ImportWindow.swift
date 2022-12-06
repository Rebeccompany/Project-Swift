//
//  ImportWindow.swift
//  
//
//  Created by Nathalia do Valle Papst on 21/11/22.
//

import ImportingFeature
import SwiftUI
import Models

#if os(macOS)
@SceneBuilder
public var ImportWindow: some Scene {
    WindowGroup("Import Flashcards", for: ImportWindowData.self) { $data in
        if let data {
            ImportView(data: data, isPresenting: .constant(true))
        } else {
            Text("error")
        }
    }
}
#endif
