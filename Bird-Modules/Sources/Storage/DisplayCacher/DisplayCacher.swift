//
//  DisplayCacher.swift
//  
//
//  Created by Rebecca Mello on 28/09/22.
//

import Foundation
import Models

public protocol DisplayCacherProtocol {
    
    func saveDetailType(detailType: DetailDisplayType)
    func getCurrentDetailType() -> DetailDisplayType?
}

public final class DisplayCacher: DisplayCacherProtocol {
    private let localStorage: LocalStorageService
    private let displayKey: String = "com.birdmodules.storage.displaycacher.displaytype"
    
    public init(localStorage: LocalStorageService = UserDefaults.standard) {
        self.localStorage = localStorage
    }
    
    public func saveDetailType(detailType: Models.DetailDisplayType) {
        self.localStorage.set(detailType.rawValue, forKey: displayKey)
    }
    
    public func getCurrentDetailType() -> Models.DetailDisplayType? {
        guard let displayTypeRawValue = self.localStorage.object(forKey: displayKey) as? String,
              let displayType = DetailDisplayType(rawValue: displayTypeRawValue)
        else { return nil }
        
        return displayType
    }
    
    
}
