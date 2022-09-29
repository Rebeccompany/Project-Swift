//
//  DependenciesStartup.swift
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
    Habitat[\.systemObserver] = SystemObserver.shared
    Habitat[\.sessionCacher] = SessionCacher()
    Habitat[\.displayCacher] = DisplayCacher()
}

public func setupHabitatForIsolatedTesting(
    deckRepository: DeckRepositoryProtocol = DeckRepositoryMock(),
    collectionRepository: CollectionRepositoryProtocol = CollectionRepositoryMock(),
    dateHandler: DateHandlerProtocol = DateHandlerMock(),
    uuidGenerator: UUIDGeneratorProtocol = UUIDHandlerMock(),
    systemObserver: SystemObserverProtocol = SystemObserverMock(),
    sessionCacher: SessionCacher = SessionCacher(storage: LocalStorageMock()),
    displayCacher: DisplayCacherProtocol = DisplayCacher(localStorage: LocalStorageMock())
) {
    Habitat[\.deckRepository] = deckRepository
    Habitat[\.collectionRepository] = collectionRepository
    Habitat[\.dateHandler] = dateHandler
    Habitat[\.uuidGenerator] = uuidGenerator
    Habitat[\.systemObserver] = systemObserver
    Habitat[\.displayCacher] = displayCacher
    Habitat[\.sessionCacher] = sessionCacher
}

public func setupHabitatForIntegrationTesting() {
    Habitat[\.deckRepository] = DeckRepositoryMock.shared
    Habitat[\.collectionRepository] = CollectionRepositoryMock.shared
    Habitat[\.dateHandler] = DateHandlerMock()
    Habitat[\.uuidGenerator] = UUIDHandlerMock()
    Habitat[\.systemObserver] = SystemObserver.shared
    Habitat[\.sessionCacher] = SessionCacher()
    Habitat[\.systemObserver] = SystemObserver.shared
    Habitat[\.sessionCacher] = SessionCacher(storage: LocalStorageMock())
    Habitat[\.displayCacher] = DisplayCacher(localStorage: LocalStorageMock())
}
