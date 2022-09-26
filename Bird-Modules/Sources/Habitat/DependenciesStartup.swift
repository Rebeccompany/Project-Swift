//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//

import Foundation
import Storage
import Utils

public func setupHabitatForProduction() {
    Habitat[\.deckRepository] = DeckRepository.shared
    Habitat[\.collectionRepository] = CollectionRepository.shared
    Habitat[\.dateHandler] = DateHandler()
    Habitat[\.uuidGenerator] = UUIDGenerator()
}

public func setupHabitatForIsolatedTesting() {
    Habitat[\.deckRepository] = DeckRepositoryMock()
    Habitat[\.collectionRepository] = CollectionRepositoryMock()
    Habitat[\.dateHandler] = DateHandlerMock()
    Habitat[\.uuidGenerator] = UUIDHandlerMock()
}

public func setupHabitatForIntegrationTesting() {
    Habitat[\.deckRepository] = DeckRepositoryMock.shared
    Habitat[\.collectionRepository] = CollectionRepositoryMock.shared
    Habitat[\.dateHandler] = DateHandlerMock()
    Habitat[\.uuidGenerator] = UUIDHandlerMock()
}
