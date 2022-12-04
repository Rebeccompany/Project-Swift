//
//  SearchDeckView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 01/12/22.
//

import SwiftUI
import Models
import HummingBird
import Habitat
import Utils

#warning("Testes e Localização")
struct SearchDeckView: View {
    
    @StateObject private var model = SearchDeckModel()
    @FocusState private var focusState: Int?
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField(
                    "search".localized(.module),
                    text: $model.searchText
                )
                    .focused($focusState, equals: 1)
                    .padding(.trailing)
                
                Picker("filter".localized(.module), selection: $model.selectedFilter) {
                    Text("name".localized(.module))
                        .tag(SearchDeckModel.FilterType.name)
                    Text("author".localized(.module))
                        .tag(SearchDeckModel.FilterType.author)
                }
            }
            .padding(.vertical, 8)
            .background(HBColor.primaryBackground)
            .cornerRadius(8)
            .padding([.horizontal, .top])
            
            Group {
                switch model.viewState {
                case .loaded:
                    loadedView
                case .error:
                    VStack {
                        Spacer()
                        ErrorView {
                            #warning("Reload")
                        }
                        Spacer()
                    }
                case .loading:
                    VStack {
                        Spacer()
                        LoadingView()
                        Spacer()
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("search".localized(.module))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("done".localized(.module)) {
                    focusState = nil
                }
            }
        }
        .onAppear(perform: model.startUp)
        .onAppear {
            focusState = 1
        }
    }
    
    @ViewBuilder
    private var loadedView: some View {
        if model.decks.isEmpty {
            VStack {
                Spacer()
                emptyView
                Spacer()
            }
        } else {
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
                                    model.loadMoreDecks()
                                }
                        } else {
                            Text("end_of_search".localized(.module))
                        }
                    }
                }
                .padding(.top)
            }
        }
    }
    
    @ViewBuilder
    private var emptyView: some View {
        VStack {
            HBImages.spixiiHacker
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background {
                    HBColor.primaryBackground
                }
                .clipShape(Circle())
                .padding(24)
        }
    }
}

struct SearchDeckView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            NavigationStack {
                SearchDeckView()
            }
        }
    }
}
