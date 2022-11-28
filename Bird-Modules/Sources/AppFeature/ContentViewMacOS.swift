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
import StoreState

#if os(macOS)
public struct ContentViewMacOS: View {
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onboarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var path: NavigationPath = .init()
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @StateObject private var shopStore = ShopStore()
    
    public init() {}
    
    public var body: some View {
        //swiftlint: disable no_navigation_view
        NavigationView {
            sidebar
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar ) {
                    Image(systemName: "sidebar.left")
                            .foregroundColor(HBColor.actionColor)
                    }
                }
            }
            detail
        }
        .navigationViewStyle(.columns)
        .onChange(of: viewModel.sidebarSelection) { _ in
            path.removeLast(path.count)
        }
        .onAppear(perform: viewModel.startup)
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $onboarding) {
            OnboardingView()
        }
        .frame(minWidth: 800, minHeight: 700)
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebarMacOS(selection: $viewModel.sidebarSelection)
            .environmentObject(viewModel)
            .environmentObject(shopStore)
            .frame(minWidth: 250)
    }
    
    @ViewBuilder
    private var detail: some View {
        NavigationStack(path: $path) {
            DetailViewMacOS()
            .environmentObject(viewModel)
            .navigationDestination(for: StudyRoute.self) { route in
                StudyRoutes.destination(for: route, viewModel: viewModel)
            }
        }
    }
    
    func toggleSidebar() {
        #if os(macOS)
        NSApp
          .keyWindow?
          .firstResponder?
          .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)),
                        with: nil)
        #endif
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
