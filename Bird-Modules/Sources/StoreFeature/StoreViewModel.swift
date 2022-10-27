//
//  StoreViewModel.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import Models
import Foundation
import Combine
import Habitat
import Puffins

public class StoreViewModel: ObservableObject {
    
    @Published var sections: [ExternalSection] = []
    @Published var viewState: ViewState = .loading
    
    @Dependency(\.externalDeckService) private var externalDeckService: ExternalDeckServiceProtocol
    
    public init() {
    }
    
    func startup() {
        externalDeckService
            .getDeckFeed()
            .handleEvents(receiveOutput: {[weak self] _ in
                self?.viewState = .loaded
            }, receiveCompletion: {[weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.viewState = .error
                }
            })
            .replaceError(with: [])
            .assign(to: &$sections)
    }
    
    private var deckListener: AnyPublisher<[ExternalSection], URLError> {
        externalDeckService.getDeckFeed()
    }
}
