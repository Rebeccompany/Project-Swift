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
                errorView()
            case .loading:
                loadingView()
            }
        }
        .navigationTitle(NSLocalizedString("baralhos_publicos", bundle: .module, comment: ""))
        .onAppear {
            interactor.bind(to: store)
            interactor.send(.loadFeed)
        }
        .viewBackgroundColor(HBColor.primaryBackground)
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
        .navigationDestination(for: ExternalDeck.self) { deck in
            PublicDeckView(deck: deck)
                .environmentObject(store)
                .environmentObject(authModel)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                signInMenu
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            AuthenticationView(model: authModel)
        }
    }
    
    @ViewBuilder
    private var signInMenu: some View {
        Menu {
            if authModel.currentLogedInUserIdentifer == nil {
                Button("signin".localized(.module)) {
                    showLogin = true
                }
            } else {
                Text("Username")
                Button("signout".localized(.module)) {
                    authModel.signOut()
                }
                Button("delete_account".localized(.module), role: .destructive) {
                    authModel.deleteAccount()
                }
            }
        } label: {
            Label {
                Text("Account")
            } icon: {
                Image(
                    systemName: authModel.currentLogedInUserIdentifer != nil ?
                    "person.crop.circle" :
                    "person.crop.circle.badge.xmark"
                )
            }

        }
    }
    
    @ViewBuilder
    private func errorView() -> some View {
        Text("error")
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        ProgressView()
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                StoreView(store: ShopStore())
                    .environmentObject(AuthenticationModel())
            }
        }
    }
}

#warning("Mover para Utils")
extension String {
    public func localized(_ bundle: Bundle) -> String {
        NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
