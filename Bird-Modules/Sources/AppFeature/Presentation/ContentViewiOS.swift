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
    
    @State private var viewModel: ContentViewModel = ContentViewModel()
    @StateObject private var appRouter: AppRouter = AppRouter()
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    public init() {}
    
    public var body: some View {
        Group {
            mainView
        }
        .navigationSplitViewStyle(.balanced)
        .sheet(isPresented: $onboarding) {
            OnboardingView()
        }
        .onChange(of: appRouter.sidebarSelection) { _, newValue in
            guard let newValue else {
                viewModel.selectedCollection = nil
                return
            }
            
            switch newValue {
            case .decksFromCollection(let collection):
                viewModel.selectedCollection = collection
            default:
                viewModel.selectedCollection = nil
            }
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
            selection: $appRouter.sidebarSelection,
            editMode: $editModeForCollection
        )
        .environment(viewModel)
        .environmentObject(appRouter)
        .environment(\.editMode, $editModeForCollection)
        .environment(\.horizontalSizeClass, horizontalSizeClass)
    }
    
    @ViewBuilder
    private var detail: some View {
        studyDetail
    }
    
    @ViewBuilder
    private var studyDetail: some View {
        NavigationStack(path: $appRouter.path) {
            DetailViewiOS(editMode: $editModeForDeck, viewModel: viewModel)
                .toolbar(
                    editModeForDeck.isEditing ? .hidden :
                            .automatic,
                    for: .tabBar)
                .environment(viewModel)
                .environment(\.editMode, $editModeForDeck)
                .navigationDestination(for: StudyRoute.self) { route in
                    StudyRoutes.destination(for: route, viewModel: viewModel)
                }
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
