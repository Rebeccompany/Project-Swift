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
        Text("Empty state")
    }
}

final class SearchDeckModel: ObservableObject {
    
    @Published var decks: [ExternalDeck] = []
    @Published var viewState: ViewState = .loaded
    @Published var searchText: String = ""
    @Published var selectedFilter: FilterType = .name
    @Published var shouldLoadMore: Bool = false
    
    private var deckService = ExternalDeckServiceMock()
    private var cancellables = Set<AnyCancellable>()
    var currentPage = 0
    
    enum FilterType: String {
        case name
        case author
    }
    
    
    func startUp() {
        searchPublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] decks in
                if let decks {
                    self?.viewState = .loaded
                    self?.shouldLoadMore = true
                    self?.decks = decks
                } else {
                    self?.viewState = .error
                }
            }
            .store(in: &cancellables)
    }
    
    //swiftlint: disable trailing_closure
    //swiftlint: disable discouraged_optional_collection
    private var searchPublisher: some Publisher<[ExternalDeck]?, Never> {
        Publishers.CombineLatest($searchText, $selectedFilter)
            .filter { !$0.0.isEmpty }
            .removeDuplicates { previous, actual in
                previous.0 == actual.0 && previous.1 == actual.1
            }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.viewState = .loading
                self?.currentPage = 0
            })
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .flatMap { [weak self] searchContent, selectedFilter in
                guard let self
                else {
                    return Fail(outputType: [ExternalDeck]?.self, failure: URLError(.badServerResponse)).eraseToAnyPublisher()
                }
                
                return self.deckService
                    .searchDecks(
                        type: selectedFilter.rawValue,
                        value: searchContent,
                        page: self.currentPage
                    )
                    .map { $0 as [ExternalDeck]? }
                    .eraseToAnyPublisher()
            }
            .replaceError(with: nil)
    }
    
    func loadMoreDecks() {
        currentPage += 1
        deckService
            .searchDecks(type: selectedFilter.rawValue, value: searchText, page: currentPage)
            .receive(on: RunLoop.main)
            .sink {[weak self] completion in
                switch completion {
                case .finished:
                    self?.viewState = .loaded
                case .failure(_):
                    self?.viewState = .error
                }
            } receiveValue: {[weak self] decks in
                if decks.isEmpty {
                    self?.shouldLoadMore = false
                } else {
                    self?.decks.append(contentsOf: decks)
                }
            }
            .store(in: &cancellables)
    }
}

struct SearchDeckCell: View {
    let deck: ExternalDeck
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: deck.icon.rawValue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .frame(width: 30, height: 30, alignment: .center)
                    .background {
                        Circle().fill(HBColor.color(for: deck.color))
                    }
                    .padding(.leading)
                    .padding(.trailing, 4)
                VStack(alignment: .leading) {
                    Text(deck.name)
                        .font(.headline)
                    Text(deck.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    HStack {
                        Text("made by \(deck.ownerName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("\(deck.cardCount) Cards")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .padding(.trailing)
                    .foregroundColor(.secondary)
            }
            Divider()
                .padding(.horizontal)
        }
        .foregroundColor(.primary)
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
