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
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
