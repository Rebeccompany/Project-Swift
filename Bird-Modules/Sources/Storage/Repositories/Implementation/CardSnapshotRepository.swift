//
//  CardSnapshotRepository.swift
//  
//
//  Created by Marcos Chevis on 05/10/22.
//

import Foundation
import Models

final class CardSnapshotRepository {
    private let dataStorage: DataStorage
    private let transformer: CardSnapshotTransformer
    
    init(transformer: CardSnapshotTransformer, dataStorage: DataStorage = .shared) {
        self.transformer = transformer
        self.dataStorage = dataStorage
    }
    
    func create(snapshot: CardSnapshot) -> CardSnapshotEntity {
        transformer.modelToEntity(snapshot, on: dataStorage.mainContext)
    }
}
