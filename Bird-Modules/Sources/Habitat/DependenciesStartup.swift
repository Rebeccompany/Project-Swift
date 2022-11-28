//
//  DependenciesStartup.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//

import Foundation
import Storage
import Puffins
import Utils
import Tweet

public func setupHabitatForProduction() {
    Habitat[\.deckRepository] = DeckRepository.shared
    Habitat[\.collectionRepository] = CollectionRepository.shared
    Habitat[\.dateHandler] = DateHandler()
    Habitat[\.uuidGenerator] = UUIDGenerator()
    Habitat[\.systemObserver] = SystemObserver.shared
    Habitat[\.displayCacher] = DisplayCacher()
    Habitat[\.externalDeckService] = ExternalDeckService.shared
    Habitat[\.notificationCenter] = NotificationService()
}

public func setupHabitatForIsolatedTesting(
    deckRepository: DeckRepositoryProtocol = DeckRepositoryMock(),
    collectionRepository: CollectionRepositoryProtocol = CollectionRepositoryMock(),
    dateHandler: DateHandlerProtocol = DateHandlerMock(),
    uuidGenerator: UUIDGeneratorProtocol = UUIDHandlerMock(),
    systemObserver: SystemObserverProtocol = SystemObserverMock(),
    displayCacher: DisplayCacherProtocol = DisplayCacher(localStorage: LocalStorageMock()),
    externalDeckService: ExternalDeckServiceProtocol = ExternalDeckServiceMock(),
    notificationCenter: NotificationServiceProtocol = NotificationService(center: UserNotificationServiceMock(), dateHandler: DateHandlerMock())
) {
    Habitat[\.deckRepository] = deckRepository
    Habitat[\.collectionRepository] = collectionRepository
    Habitat[\.dateHandler] = dateHandler
    Habitat[\.uuidGenerator] = uuidGenerator
    Habitat[\.systemObserver] = systemObserver
    Habitat[\.displayCacher] = displayCacher
    Habitat[\.externalDeckService] = externalDeckService
    Habitat[\.notificationCenter] = notificationCenter
}

public func setupHabitatForIntegrationTesting() {
    Habitat[\.deckRepository] = DeckRepositoryMock()
    Habitat[\.collectionRepository] = CollectionRepositoryMock.shared
    Habitat[\.dateHandler] = DateHandlerMock()
    Habitat[\.uuidGenerator] = UUIDHandlerMock()
    Habitat[\.systemObserver] = SystemObserver.shared
    Habitat[\.systemObserver] = SystemObserver.shared
    Habitat[\.displayCacher] = DisplayCacher(localStorage: LocalStorageMock())
    Habitat[\.externalDeckService] = ExternalDeckServiceMock()
}
