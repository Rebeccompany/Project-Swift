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
import Puffins
import Combine
#warning("Testes e Localização")
struct SearchDeckView: View {
    
    @StateObject private var model = SearchDeckModel()
    @FocusState private var focusState: Int?
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("Search", text: $model.searchText)
                    .focused($focusState, equals: 1)
                    .padding(.trailing)
                
                Picker("Filter", selection: $model.selectedFilter) {
                    Text("Name").tag(SearchDeckModel.FilterType.name)
                    Text("Author").tag(SearchDeckModel.FilterType.author)
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
                    ErrorView {
                        
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
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
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
                            Text("That's all folks")
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
