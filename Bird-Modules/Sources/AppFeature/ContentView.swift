//
//  ContentView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import SwiftUI
import Models
import DeckFeature
import NewDeckFeature
import HummingBird
import Flock
import NewCollectionFeature
import Habitat
import Storage
import OnboardingFeature

public struct ContentView: View {
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onBoarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var editModeForCollection: EditMode = .inactive
    @State private var editModeForDeck: EditMode = .inactive
    @State private var path: NavigationPath = .init()
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } detail: {
            detail
        }
        .onChange(of: viewModel.sidebarSelection) { _ in
            path.removeLast(path.count - 1)
        }
        .onAppear(perform: viewModel.startup)
        .navigationSplitViewStyle(.balanced)
        
        .sheet(isPresented: $onBoarding) {
            OnboardingView()
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebar(
            selection: $viewModel.sidebarSelection,
            isCompact: horizontalSizeClass == .compact,
            editMode: $editModeForCollection
        )
        .environmentObject(viewModel)
        .environment(\.editMode, $editModeForCollection)
    }
    
    @ViewBuilder
    private var detail: some View {
        Router(path: $path) {
            DetailView(editMode: $editModeForDeck)
            .environmentObject(viewModel)
            .environment(\.editMode, $editModeForDeck)
        } destination: { (route: StudyRoute) in
            StudyRoutes.destination(for: route, viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            ContentView()
        }
    }
}
