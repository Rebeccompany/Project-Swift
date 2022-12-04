//
//  DeckCategoryView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 03/12/22.
//

import SwiftUI
import Models
import Habitat
import Combine
import Utils
import Puffins

#warning("Localizar e Testes")
struct DeckCategoryView: View {
    
    let category: DeckCategory
    @StateObject private var model = DeckCategoryModel()
    
    var body: some View {
        Group {
            switch model.viewState {
            case .loaded:
                ScrollView {
                    LazyVStack {
                        Section {
                            ForEach(model.decks) { deck in
                                NavigationLink(value: deck) {
                                    SearchDeckCell(deck: deck)
                                }
                            }
                        } footer: {
                            if model.shouldLoadMore {
                                ProgressView()
                                    .onAppear {
                                        model.loadMoreDecks(from: category)
                                    }
                            }
                        }

                    }
                    .padding(.top)
                }
            case .loading:
                LoadingView()
            case .error:
                ErrorView {
                    model.startUp(with: category)
                }
            }
        }
        .refreshable {
            model.startUp(with: category)
        }
        .navigationTitle(category.rawValue.localized(.module))
        .onAppear {
            model.startUp(with: category)
        }
    }
    
}

struct DeckCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                DeckCategoryView(category: .humanities)
            }
        }
    }
}
