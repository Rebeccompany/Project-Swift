//
//  StoreView.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import SwiftUI
import HummingBird
import Habitat
import Models
import Peacock
import Utils
import PublicDeckFeature
import Authentication
import StoreState

public struct StoreView: View {
    @ObservedObject private var store: ShopStore
    @StateObject private var interactor = FeedInteractor()
    @EnvironmentObject private var authModel: AuthenticationModel
    @State private var showLogin: Bool = false
    
    public init(store: ShopStore) {
        self.store = store
    }
    
    public var body: some View {
        let state = store.feedState
        Group {
            switch state.viewState {
            case .loaded:
                loadedFeed(state: state)
            case .error:
                ErrorView { interactor.send(.loadFeed) }
            case .loading:
                LoadingView()
            }
        }
        .navigationTitle(NSLocalizedString("baralhos_publicos", bundle: .module, comment: ""))
        .onAppear {
            interactor.bind(to: store)
            interactor.send(.loadFeed)
        }
        .navigationDestination(for: ExternalDeck.self) { deck in
            PublicDeckView(deck: deck)
                .environmentObject(store)
                .environmentObject(authModel)
        }
        .navigationDestination(for: FilterRoute.self) { route in
            switch route {
            case .search:
                SearchDeckView()
            case .category(let category):
                DeckCategoryView(category: category)
            }
        }
    }
    
    @ViewBuilder
    private func loadedFeed(state: FeedState) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(state.sections.filter { !$0.decks.isEmpty }) { section in
                    PublicSection(section: section)
                    
                }
            }
        }
        .refreshable {
            interactor.send(.loadFeed)
        }
        #if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                NavigationLink(value: FilterRoute.search) {
                    Label("search".localized(.module), systemImage: "magnifyingglass")
                }
                signInMenu
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            AuthenticationView(model: authModel)
        }
        #elseif os(macOS)
        .toolbar {
            ToolbarItemGroup {
                NavigationLink(value: FilterRoute.search) {
                    Label("search".localized(.module), systemImage: "magnifyingglass")
                }
                signInMenu
            }
        }
        .sheet(isPresented: $showLogin) {
            AuthenticationView(model: authModel)
        }
        #endif
        
    }
    
    @ViewBuilder
    private var signInMenu: some View {
        Menu {
            if let user = authModel.user {
                Text(user.username)
                Button("signout".localized(.module)) {
                    authModel.signOut()
                }
                Button("delete_account".localized(.module), role: .destructive) {
                    authModel.deleteAccount()
                }
            } else {
                Button("signin".localized(.module)) {
                    showLogin = true
                }
            }
        } label: {
            Label {
                Text("Account")
            } icon: {
                Image(
                    systemName: authModel.user != nil ?
                    "person.crop.circle" :
                        "person.crop.circle.badge.xmark"
                )
            }
            
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                StoreView(store: ShopStore(feedState: FeedState(sections: [], viewState: .loading)))
                    .environmentObject(AuthenticationModel())
            }
        }
    }
}
