//
//  File.swift
//  
//
//  Created by Rebecca Mello on 28/10/22.
//

import Foundation
import Models
import Combine
import Habitat

public class PublicDeckViewModel: ObservableObject {

    @Dependency(\.externalDeckService) var deckService
    
    @Published var cards: [ExternalCard] = []
    @Published var currentPage: Int = 0
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    func fetchCards(deckId: String) {
        deckService
            .getCardsFor(deckId: deckId, page: currentPage)
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: {[weak self] completion in
                if completion == .finished {
                    self?.currentPage += 1
                } else {
                    self?.currentPage = 0
                }
            })
            .sink { completion in
                
            } receiveValue: {[weak self] newCards in
                self?.cards.append(contentsOf: newCards)
            }
            .store(in: &cancellables)

    }
    
    func reloadCards(deckId: String) {
        deckService
            .getCardsFor(deckId: deckId, page: 0)
            .receive(on: RunLoop.main)
            .handleEvents(receiveCompletion: {[weak self] _ in self?.currentPage = 0 })
            .sink { completion in
                
            } receiveValue: {[weak self] cards in
                self?.cards = cards
            }
            .store(in: &cancellables)
    }
}
