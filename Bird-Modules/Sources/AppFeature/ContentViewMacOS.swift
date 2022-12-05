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
        NavigationSplitView {
            sidebar
        } detail: {
            detail
        }
        .navigationViewStyle(.columns)
        .onChange(of: appRouter.sidebarSelection) { newValue in
            appRouter.path.removeLast(appRouter.path.count)
            switch newValue {
            case .decksFromCollection(let collection):
                viewModel.selectedCollection = collection
            default:
                viewModel.selectedCollection = nil
            }
        }
        .onAppear(perform: viewModel.startup)
        .navigationSplitViewStyle(.balanced)
        .onOpenURL { appRouter.onOpen(url: $0) }
        .sheet(isPresented: $onboarding) {
            OnboardingView()
                .frame(minWidth: 400, minHeight: 500)
        }
        .onChange(of: appRouter.path) { newValue in
            print(newValue, newValue.count)
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebarMacOS(selection: $appRouter.sidebarSelection)
            .environmentObject(viewModel)
            .environmentObject(shopStore)
            .environmentObject(authModel)
            .environmentObject(appRouter)
            .frame(minWidth: 250)
    }
    
    @ViewBuilder
    private var detail: some View {
        switch appRouter.sidebarSelection {
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
    
}

struct ContentViewMacOS_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            ContentViewMacOS()
        }
    }
}
#endif
