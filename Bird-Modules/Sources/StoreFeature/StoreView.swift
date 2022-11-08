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
import StoreState

public struct StoreView: View {
    @ObservedObject private var store: ShopStore
    @StateObject private var interactor = FeedInteractor()
    
    public init(store: ShopStore) {
        self.store = store
    }
    
    public var body: some View {
        let state = store.feedState
        Group {
            switch state.viewState {
            case .loaded:
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(state.sections) { section in
                            PublicSection(section: section)
                        }
                    }
                }
                .navigationDestination(for: ExternalDeck.self) { deck in
                    PublicDeckView(deck: deck)
                        .environmentObject(store)
                }
            case .error:
                Text("Error")
            case .loading:
                ProgressView()
            }
        }
        .navigationTitle(NSLocalizedString("baralhos_publicos", bundle: .module, comment: ""))
        .onAppear {
            interactor.bind(to: store)
            interactor.send(.loadFeed)
        }
        .viewBackgroundColor(HBColor.primaryBackground)
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                StoreView(store: ShopStore())
            }
        }
    }
}
