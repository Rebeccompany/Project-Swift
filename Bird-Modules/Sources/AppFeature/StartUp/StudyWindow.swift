//
//  StudyWindow.swift
//  
//
//  Created by Nathalia do Valle Papst on 08/11/22.
//

import Foundation
import SwiftUI
import Models
import StudyFeature

#if os(macOS)
@SceneBuilder
public var studyWindow: some Scene {
    WindowGroup("Study", for: StudyWindowData.self) { $data in
        if let data {
            StudyViewMacOS(data: data)
                .frame(minWidth: 1024, minHeight: 640)
        } else {
            Text("error")
        }
    }
}
#endif
