//
//  NewFlashcardWindow.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 31/10/22.
//

import NewFlashcardFeature
import SwiftUI
import Models

#if os(macOS)
@SceneBuilder
public var newFlashcardWindow: some Scene {
    WindowGroup("New Flashcard", for: NewFlashcardWindowData.self) { $data in
        if let data {
            NewFlashcardViewMacOS(data: data)
                .frame(minWidth: 1024, minHeight: 640)
        } else {
            Text("error")
        }
    }
}
#endif
