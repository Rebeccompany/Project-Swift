//
//  FeedState.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 08/11/22.
//

import Foundation
import Models

public struct FeedState: Equatable {
    public var sections: [ExternalSection]
    public var viewState: ViewState
    
    public init(sections: [ExternalSection] = [], viewState: ViewState = .loading) {
        self.sections = sections
        self.viewState = viewState
    }
}
