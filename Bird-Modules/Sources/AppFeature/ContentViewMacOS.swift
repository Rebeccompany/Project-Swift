//
//  ContentViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 24/10/22.
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

#if os(macOS)
public struct ContentViewMacOS: View {
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onboarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var path: NavigationPath = .init()
    
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
        .frame(minWidth: 600, minHeight: 500)
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebarMacOS(selection: viewModel.macOSSidebarSelection)
            .environmentObject(viewModel)
            .frame(minWidth: 250)
    }
    
    @ViewBuilder
    private var detail: some View {
        Router(path: $path) {
            DetailViewMacOS()
                .environmentObject(viewModel)
        } destination: { (route: StudyRoute) in
            StudyRoutes.destination(for: route, viewModel: viewModel)
        }
    }
}

struct ContentViewMacOS_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            ContentViewMacOS()
        }
    }
}
#endif
