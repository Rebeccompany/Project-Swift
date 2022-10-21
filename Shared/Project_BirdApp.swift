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
    #elseif os(macOS)
    
    #endif
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
