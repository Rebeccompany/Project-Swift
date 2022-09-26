//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//

import Storage
import Utils

// MARK: Keys

private struct DeckRepositoryKey: HabitatKey {
    static var currentValue: DeckRepositoryProtocol = DeckRepository.shared
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
}
