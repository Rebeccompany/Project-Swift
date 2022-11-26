//
//  ContentView.swift
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

public struct ContentView: View {
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onboarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var editModeForCollection: EditMode = .inactive
    @State private var editModeForDeck: EditMode = .inactive
    @State private var path: NavigationPath = .init()
    @State private var storePath: NavigationPath = .init()
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @StateObject private var authModel: AuthenticationModel = AuthenticationModel()
    @StateObject private var shopStore = ShopStore()
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    public init() {}
    
    public var body: some View {
        if horizontalSizeClass == .compact {
            TabView {
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
                .tabItem {
                    Label {
                        Text("baralhos", bundle: .module)
                    } icon: {
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    }
                }
                
                NavigationStack(path: $storePath) {
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
            }
            .toolbarBackground(.visible, for: .tabBar)
        } else {
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
        }
    }
    
@ViewBuilder
    private var mainView: some View {
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
    }
    
    @ViewBuilder
    private var sidebar: some View {
        CollectionsSidebar(
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
        Router(path: $path) {
            DetailView(editMode: $editModeForDeck)
                .toolbar(
                    editModeForDeck.isEditing ? .hidden :
                            .automatic,
                    for: .tabBar)
                .environmentObject(viewModel)
                .environmentObject(authModel)
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
