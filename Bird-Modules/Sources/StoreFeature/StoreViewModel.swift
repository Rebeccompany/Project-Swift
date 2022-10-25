//
//  StoreViewModel.swift
//  
//
//  Created by Rebecca Mello on 21/10/22.
//

import Models
import HummingBird
import Combine
import DeckFeature
import Storage
import Habitat
import SwiftUI
import Puffins

public class StoreViewModel: ObservableObject {
    
    @Published var sections: [ExternalSection] = []
    @Published var viewState: ViewState = .loading
    
    private var externalDeckService: ExternalDeckServiceProtocol = ExternalDeckServiceMock()
    
    public init() {
    }
    
    func startup() {
        externalDeckService
            .getDeckFeed()
            .delay(for: .seconds(3), scheduler: RunLoop.main)
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
