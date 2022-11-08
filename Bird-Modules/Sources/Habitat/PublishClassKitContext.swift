//
//  File.swift
//  
//
//  Created by Rebecca Mello on 08/11/22.
//

import Foundation
import Models
import ClassKit

public func publishContextIfNeeded(completion: ((Error?) -> Void)? = nil) {
    let deckContext = CLSContext(type: .custom, identifier: "deck", title: "Deck")
    
    let spixiiStudyContext = CLSContext(type: .task, identifier: "spixiiStudy", title: "Spixii Study")
    spixiiStudyContext.displayOrder = 0
    
    let intenseStudyContext = CLSContext(type: .task, identifier: "intenseStudy", title: "Intense Study")
    intenseStudyContext.displayOrder = 1
    
    var deckContextToCreate: [String: CLSContext] = [
        deckContext.identifier: deckContext
    ]
    
    var studyContextsToCreate: [String: CLSContext] = [
        spixiiStudyContext.identifier: spixiiStudyContext,
        intenseStudyContext.identifier: intenseStudyContext
    ]
    
    let deckParent = CLSDataStore.shared.mainAppContext
    let deckPredicate = NSPredicate(format: "parent = %@", deckParent)
    CLSDataStore.shared.contexts(matching: deckPredicate) { contexts, error in
        for context in contexts {
            deckContextToCreate.removeValue(forKey: context.identifier)
        }
        for (_, context) in deckContextToCreate {
            deckParent.addChildContext(context)
        }
    }
    
    let studyParent = deckContext
    let studyPredicate = NSPredicate(format: "parent = %@", studyParent)
    CLSDataStore.shared.contexts(matching: studyPredicate) { contexts, error in
        for context in contexts {
            studyContextsToCreate.removeValue(forKey: context.identifier)
        }
        for (_, context) in studyContextsToCreate {
            studyParent.addChildContext(context)
        }
    }
    
    CLSDataStore.shared.save() { (error) in
        completion?(error)
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
