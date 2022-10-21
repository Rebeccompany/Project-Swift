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
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onboarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var path: NavigationPath = .init()
    #if os(iOS)
    @State private var editModeForCollection: EditMode = .inactive
    @State private var editModeForDeck: EditMode = .inactive
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    
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
        .sheet(isPresented: $onboarding) {
            OnboardingView()
        }
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 500)
        #endif
    }
    
    @ViewBuilder
    private var sidebar: some View {
        #if os(iOS)
        CollectionsSidebar(
            selection: $viewModel.sidebarSelection,
            isCompact: horizontalSizeClass == .compact,
            editMode: $editModeForCollection
        )
        .environmentObject(viewModel)
        .environment(\.editMode, $editModeForCollection)
        #elseif os(macOS)
        CollectionsSidebar(selection: $viewModel.sidebarSelection)
            .environmentObject(viewModel)
            .frame(minWidth: 250)
        #endif
    }
    
    @ViewBuilder
    private var detail: some View {
        Router(path: $path) {
            #if os(iOS)
            DetailView(editMode: $editModeForDeck)
            .environmentObject(viewModel)
            .environment(\.editMode, $editModeForDeck)
            #elseif os(macOS)
            DetailView()
                .environmentObject(viewModel)
            #endif
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
