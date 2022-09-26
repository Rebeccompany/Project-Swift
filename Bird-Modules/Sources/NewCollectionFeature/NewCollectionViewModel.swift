//
//  NewCollectionViewModel.swift
//  
//
//  Created by Caroline Taus on 06/09/22.
//

import SwiftUI
import Models
import Storage
import Combine
import Utils
import Habitat

@MainActor
public class NewCollectionViewModel: ObservableObject {
    @Published var collectionName: String = ""
    @Published var currentSelectedIcon: IconNames? = IconNames.gamecontroller
    @Published var canSubmit: Bool = false
    
    @Dependency(\.dateHandler) private var dateHandler: DateHandlerProtocol
    @Dependency(\.uuidGenerator) private var idGenerator: UUIDGeneratorProtocol
    @Dependency(\.collectionRepository) private var collectionRepository: CollectionRepositoryProtocol
    let icons: [IconNames] = IconNames.allCases
    
//    public init(
//        collectionRepository: CollectionRepositoryProtocol = CollectionRepository.shared,
//        dateHandler: DateHandlerProtocol = DateHandler(),
//        idGenerator: UUIDGeneratorProtocol = UUIDGenerator(),
//        editingCollection: DeckCollection? = nil
//    ) {
//        self.icons = IconNames.allCases
//        self.collectionRepository = collectionRepository
//        self.dateHandler = dateHandler
//        self.idGenerator = idGenerator
//        self.canSubmit = false
//        self.editingCollection = editingCollection
//
//        if let editingCollection = editingCollection {
//            setupCollectionContentIntoFields(collection: editingCollection)
//        }
//
//    }
    
    private func setupCollectionContentIntoFields(collection: DeckCollection) {
        collectionName = collection.name
        currentSelectedIcon = collection.icon
    }
    
    private var canSubmitPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($collectionName, $currentSelectedIcon)
            .map { name, currentSelectedIcon in !name.isEmpty && currentSelectedIcon != nil }
            .eraseToAnyPublisher()
    }
    
    func startUp(editingCollection: DeckCollection?) {
        canSubmitPublisher
            .assign(to: &$canSubmit)
        
        if let editingCollection = editingCollection {
                setupCollectionContentIntoFields(collection: editingCollection)
            }
    }
    
    
    func createCollection() throws {
        guard let currentSelectedIcon
        else { return }
        
        try collectionRepository.createCollection(newCollection(selectedIcon: currentSelectedIcon))
    }
    
    func newCollection(selectedIcon: IconNames) -> DeckCollection {
        DeckCollection(
            id: idGenerator.newId(),
            name: collectionName,
            icon: selectedIcon,
            datesLogs: DateLogs(
                lastAccess: dateHandler.today,
                lastEdit: dateHandler.today,
                createdAt: dateHandler.today),
            decksIds: [])
    }
    
    func editCollection(editingCollection: DeckCollection?) throws {
        guard let currentSelectedIcon,
            let editingCollectionUnwraped = editingCollection
        else {
            return
        }
        
        var editingCollection = editingCollectionUnwraped
        editingCollection.name = collectionName
        editingCollection.icon = currentSelectedIcon
        editingCollection.datesLogs.lastAccess = dateHandler.today
        editingCollection.datesLogs.lastEdit = dateHandler.today
        try collectionRepository.editCollection(editingCollection)
    }
    
    func deleteCollection(editingCollection: DeckCollection?) throws {
        guard let editingCollection = editingCollection
        else { return }
        try collectionRepository.deleteCollection(editingCollection)
    }
}
