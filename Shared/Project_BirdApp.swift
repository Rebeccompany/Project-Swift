//
//  Project_BirdApp.swift
//  Shared
//
//  Created by Marcos Chevis on 08/08/22.
//

import SwiftUI
import AppFeature

@main
struct Project_BirdApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            ContentViewiOS()
            #elseif os(macOS)
            ContentViewMacOS()
                .frame(minWidth: 1024, minHeight: 640)
            #endif
        }
        
        #if os(macOS)
        NewFlashcardWindow
        StudyWindow
        ImportWindow
        #endif
    }
}
