//
//  ContextRequestHandler.swift
//  Project-BirdClassKitContextProvider
//
//  Created by Marcos Chevis on 23/11/22.
//

import ClassKit
import Storage
import AppFeature

import Combine
final class ContextRequestHandler: NSObject, NSExtensionRequestHandling, CLSContextProvider {
    
    var deckRepository: DeckRepositoryProtocol = DeckRepository.shared
    var cancellables: Set<AnyCancellable> = .init()
    
    func beginRequest(with context: NSExtensionContext) {}
    
    func updateDescendants(of context: CLSContext, completion: @escaping (Error?) -> Void) {
        deckRepository
            .deckListener()
            .first()
            .map {
                $0.filter {deck in deck.storeId != nil }
            }
            .sink { sinkCompletion in
                switch sinkCompletion {
                case .finished:
                    CLSDataStore.shared.save { error in
                        completion(error)
                    }
                case .failure(let error):
                    completion(error)
                }
            } receiveValue: { decks in
                CLSDeckLibrary.shared.addDecks(decks, creatingContexts: false)
                
            }
            .store(in: &cancellables)

    }
}
