//
//  ContentViewiOS.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 14/09/22.
//

import Flock
import Models
import SwiftUI
import Habitat
import Storage
import StoreState
import DeckFeature
import HummingBird
import StoreFeature
import NewDeckFeature
import Authentication
import OnboardingFeature
import NewCollectionFeature

#if os(iOS)
public struct ContentViewiOS: View {
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onboarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var editModeForCollection: EditMode = .inactive
    @State private var editModeForDeck: EditMode = .inactive
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @StateObject private var appRouter: AppRouter = AppRouter()
    @StateObject private var shopStore: ShopStore = ShopStore()
    @StateObject private var authModel: AuthenticationModel = AuthenticationModel()
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    public init() {}
    
    public var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                TabView(selection: $appRouter.selectedTab) {
                    mainView
                        .tabItem {
                            Label {
                                Text("baralhos", bundle: .module)
                            } icon: {
                                Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                            }
                        }
                        .tag(AppRouter.Tab.study)
                    
                    NavigationStack(path: $appRouter.storePath) {
                        StoreView(store: shopStore)
                            .environmentObject(authModel)
                    }
                    .tabItem {
                        Label {
                            Text("library", bundle: .module)
                        } icon: {
                            Image(systemName: "books.vertical")
                        }
                    }
                    .tag(AppRouter.Tab.store)
                }
                
            } else {
                mainView
            }
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $onboarding) {
            OnboardingView()
        }
        .onChange(of: viewModel.sidebarSelection) { _ in
            appRouter.path.removeLast(appRouter.path.count - 1)
        }
        .onAppear(perform: viewModel.startup)
        .onOpenURL { appRouter.onOpen(url: $0) }
    }
    
    @ViewBuilder
    private var mainView: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } detail: {
            detail
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebariOS(
            selection: $viewModel.sidebarSelection,
            editMode: $editModeForCollection
        )
        .environmentObject(viewModel)
        .environmentObject(shopStore)
        .environmentObject(authModel)
        .environment(\.editMode, $editModeForCollection)
        .environment(\.horizontalSizeClass, horizontalSizeClass)
    }
    
    @ViewBuilder
    private var detail: some View {
        Router(path: $appRouter.path) {
            DetailViewiOS(editMode: $editModeForDeck)
                .toolbar(
                    editModeForDeck.isEditing ? .hidden :
                            .automatic,
                    for: .tabBar)
                .environmentObject(viewModel)
                .environmentObject(authModel)
                .environment(\.editMode, $editModeForDeck)
        } destination: { (route: StudyRoute) in
            StudyRoutes.destination(for: route, viewModel: viewModel)
                .environmentObject(authModel)
        }
    }
}

struct ContentViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            ContentViewiOS()
        }
    }
}
#endif
