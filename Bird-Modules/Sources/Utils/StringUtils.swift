//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/11/22.
//

import Foundation

extension String {
    public func localized(_ bundle: Bundle) -> String {
        NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
