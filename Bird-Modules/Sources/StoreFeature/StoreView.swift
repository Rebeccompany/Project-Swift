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
import PublicDeckFeature

public struct StoreView: View {
    @StateObject private var viewModel: StoreViewModel = StoreViewModel()
    
    public init() { }
    
    public var body: some View {
        Group {
            switch viewModel.viewState {
            case .loaded:
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(viewModel.sections) { section in
                            PublicSection(section: section)
                        }
                    }
                }
            case .error:
                Text("Error")
            case .loading:
                ProgressView()
            }
        }
        .navigationTitle(NSLocalizedString("baralhos_publicos", bundle: .module, comment: ""))
        .onAppear(perform: viewModel.startup)
        .viewBackgroundColor(HBColor.primaryBackground)
        .navigationDestination(for: ExternalDeck.self) { deck in
            PublicDeckView(deck: deck)
        }
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                StoreView()
            }
        }
    }
}
