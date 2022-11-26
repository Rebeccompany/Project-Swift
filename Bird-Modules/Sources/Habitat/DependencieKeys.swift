//
//  DependencieKeys.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//
import Foundation
import Storage
import Puffins
import Utils

// MARK: Keys

private struct DeckRepositoryKey: HabitatKey {
    static var currentValue: DeckRepositoryProtocol = DeckRepository.shared
}

private struct ExternalDeckServiceKey: HabitatKey {
    static var currentValue: ExternalDeckServiceProtocol = ExternalDeckService.shared
}

private struct CollectionRepositoryKey: HabitatKey {
    static var currentValue: CollectionRepositoryProtocol = CollectionRepository.shared
}

private struct DateHandlerKey: HabitatKey {
    static var currentValue: DateHandlerProtocol = DateHandler()
}

private struct UUIDGeneratorKey: HabitatKey {
    static var currentValue: UUIDGeneratorProtocol = UUIDGenerator()
}

private struct SystemObserverKey: HabitatKey {
    static var currentValue: SystemObserverProtocol = SystemObserver.shared
}

private struct DisplayCacherKey: HabitatKey {
    static var currentValue: DisplayCacherProtocol = DisplayCacher()
}

private struct ExternalUserServiceKey: HabitatKey {
    static var currentValue: ExternalUserServiceProtocol = ExternalUserService.shared
}

// MARK: Extension
extension Habitat {
    public var deckRepository: DeckRepositoryProtocol {
        get { Self[DeckRepositoryKey.self] }
        set { Self[DeckRepositoryKey.self] = newValue }
    }
    
    public var collectionRepository: CollectionRepositoryProtocol {
        get { Self[CollectionRepositoryKey.self] }
        set { Self[CollectionRepositoryKey.self] = newValue }
    }
    
    public var dateHandler: DateHandlerProtocol {
        get { Self[DateHandlerKey.self] }
        set { Self[DateHandlerKey.self] = newValue }
    }
    
    public var uuidGenerator: UUIDGeneratorProtocol {
        get { Self[UUIDGeneratorKey.self] }
        set { Self[UUIDGeneratorKey.self] = newValue }
    }
    
    public var systemObserver: SystemObserverProtocol {
        get { Self[SystemObserverKey.self] }
        set { Self[SystemObserverKey.self] = newValue }
    }
    
    public var displayCacher: DisplayCacherProtocol {
        get { Self[DisplayCacherKey.self] }
        set { Self[DisplayCacherKey.self] = newValue }
    }
    
    public var externalDeckService: ExternalDeckServiceProtocol {
        get { Self[ExternalDeckServiceKey.self] }
        set { Self[ExternalDeckServiceKey.self] = newValue }
    }
    
    public var externalUserService: ExternalUserServiceProtocol {
        get { Self[ExternalUserServiceKey.self] }
        set { Self[ExternalUserServiceKey.self] = newValue }
    }
}
