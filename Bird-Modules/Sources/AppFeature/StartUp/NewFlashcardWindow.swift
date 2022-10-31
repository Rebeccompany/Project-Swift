//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 31/10/22.
//

import NewFlashcardFeature
import SwiftUI
import Models

@SceneBuilder
public var newFlashcardWindow: some Scene {
    WindowGroup("New Flashcard", for: NewFlashcardWindowData.self) { $data in
        if let data {
            NewFlashcardViewMacOS(data: data)
        } else {
            Text("error")
        }
    }
}
