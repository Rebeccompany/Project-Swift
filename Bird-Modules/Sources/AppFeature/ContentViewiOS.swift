//
//  ContentViewiOS.swift
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
import StoreFeature
import OnboardingFeature
import StoreState

#if os(iOS)
public struct ContentViewiOS: View {
    @AppStorage("com.projectbird.birdmodules.appfeature.onboarding") private var onboarding: Bool = true
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State private var editModeForCollection: EditMode = .inactive
    @State private var editModeForDeck: EditMode = .inactive
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var path: NavigationPath = .init()
    @State private var storePath: NavigationPath = .init()
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @StateObject private var shopStore = ShopStore()
    
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
        CollectionsSidebariOS(
            selection: $viewModel.sidebarSelection,
            editMode: $editModeForCollection
        )
        .environmentObject(viewModel)
        .environmentObject(shopStore)
        .environment(\.editMode, $editModeForCollection)
        .environment(\.horizontalSizeClass, horizontalSizeClass)
    }
    
    @ViewBuilder
    private var detail: some View {
        Router(path: $path) {
            DetailViewiOS(editMode: $editModeForDeck)
                .toolbar(
                    editModeForDeck.isEditing ? .hidden :
                            .automatic,
                    for: .tabBar)
                .environmentObject(viewModel)
                .environment(\.editMode, $editModeForDeck)
        } destination: { (route: StudyRoute) in
            StudyRoutes.destination(for: route, viewModel: viewModel)
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