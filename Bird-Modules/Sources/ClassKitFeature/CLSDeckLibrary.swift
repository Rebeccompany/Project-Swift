//
//  File.swift
//  
//
//  Created by Marcos Chevis on 23/11/22.
//

import ClassKit
import Combine
import Models
import Storage

public final class CLSDeckLibrary: NSObject {
    
    public static var shared = CLSDeckLibrary()
    
    private(set) var decks: [Deck] = []
    
    var deckRepository: DeckRepositoryProtocol = DeckRepository.shared
    var cancellables: Set<AnyCancellable> = .init()
    
    override private init() {
        super.init()
        setupClassKit()
    }
    
    private func setupClassKit() {
        CLSDataStore.shared.delegate = self
    }
    
    private func setupContext(for deck: Deck) {
        CLSDataStore.shared.mainAppContext.descendant(matchingIdentifierPath: deck.identifierPath) { _, _ in }
    }
 
    public func updateDescendants(of context: CLSContext, completion: @escaping (Error?) -> Void) {
        deckRepository
            .deckListener()
            .first()
            .map {
                $0.filter { deck in deck.storeId != nil }
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
                self.addDecks(decks, creatingContexts: false)
                
            }
            .store(in: &cancellables)
    }
    
    public func addStoreDecks() {
        deckRepository
            .deckListener()
            .first()
            .map {
                $0.filter { deck in deck.storeId != nil }
            }
            .replaceError(with: [])
            .sink { decks in
                self.addDecks(decks)
            }
            .store(in: &cancellables)
    }
    
    private func addDecks(_ decks: [Deck], creatingContexts: Bool = true) {
        decks.forEach { deck in
            addDeck(deck, creatingContexts: creatingContexts)
        }
    }
    
    func addDeck(_ deck: Deck, creatingContexts: Bool = true) {
        if !decks.contains(where: { $0.storeId == deck.storeId }) {
            decks.append(deck)
            
            // Give ClassKit a chance to set up its contexts.
            if creatingContexts {
                setupContext(for: deck)
            }
        }
    }
}

extension CLSDeckLibrary: CLSDataStoreDelegate {
    public func createContext(forIdentifier identifier: String, parentContext: CLSContext, parentIdentifierPath: [String]) -> CLSContext? {
        
        let identifierPath = parentIdentifierPath + [identifier]
        
        guard let deckIdentifier = identifierPath.first,
              let deckNode = Self.shared.decks.first(where: { $0.identifier == deckIdentifier }) else {
            return nil
        }
        
        let context = CLSContext(type: deckNode.contextType, identifier: identifier, title: deckNode.identifier)
        context.topic = .science
        context.title = deckNode.title
        
        context.universalLinkURL = URL(string: "spixii://" + deckIdentifier)
        
        return context
    }
    
    
}
