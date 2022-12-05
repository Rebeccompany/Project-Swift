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
import Authentication
import StoreState
import StoreFeature

#if os(macOS)
public struct ContentViewMacOS: View {
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onboarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var path: NavigationPath = .init()
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @StateObject private var shopStore = ShopStore()
    @StateObject private var appRouter: AppRouter = AppRouter()
    @StateObject private var authModel: AuthenticationModel = AuthenticationModel()
    
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
                .frame(minWidth: 400, minHeight: 500)
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebarMacOS(selection: $viewModel.sidebarSelection)
            .environmentObject(viewModel)
            .environmentObject(shopStore)
            .environmentObject(authModel)
            .frame(minWidth: 250)
    }
    
    @ViewBuilder
    private var detail: some View {
        switch viewModel.sidebarSelection {
        case .store:
            storeDetail
        default:
            studyDetail
        }
    }
    
    @ViewBuilder
    private var studyDetail: some View {
        NavigationStack(path: $appRouter.path) {
            DetailViewMacOS()
            .environmentObject(viewModel)
            .environmentObject(authModel)
            .navigationDestination(for: StudyRoute.self) { route in
                StudyRoutes.destination(for: route, viewModel: viewModel)
                    .environmentObject(authModel)
            }
        }
    }
    
    @ViewBuilder
    private var storeDetail: some View {
        NavigationStack(path: $appRouter.storePath) {
            StoreView(store: shopStore)
                .environmentObject(authModel)
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
