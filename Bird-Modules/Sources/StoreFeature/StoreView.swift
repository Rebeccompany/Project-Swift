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
    @State private var isFlipped: Bool = false
    
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
            //interactor.send(.loadFeed)
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
    
    @ViewBuilder
    private func errorView() -> some View {
        VStack {
            HBImages.errorSpixii
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .clipShape(Circle())
                .background {
                    Circle().fill(HBColor.secondaryBackground)
                }
                .frame(maxWidth: 300)
            
            Text("Oh no!, something is wrong, check your internet connection and press the button bellow to try again.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
                .padding(.bottom)
            
            Button {
                interactor.send(.loadFeed)
            } label: {
                Label {
                    Text("Retry")
                } icon: {
                    Image(systemName: "gobackward")
                }

            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .frame(maxWidth: 320)
        }
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(HBColor.actionColor)
                    .brightness(0.1)
                SpixiiShapeFront()
                    .fill(HBColor.actionColor)
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            .rotationEffect(
                isFlipped ? Angle(degrees: 0) : Angle(degrees: 360),
                anchor: .center)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).delay(0.5).repeatForever(autoreverses: true)) {
                    isFlipped.toggle()
                }
            }
            .onDisappear {
                isFlipped = false
            }
            Text("Loading...")
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

