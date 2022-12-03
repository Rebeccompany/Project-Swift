//
//  String+localized.swift
//  
//
//  Created by Marcos Chevis on 29/11/22.
//

import Foundation

extension String {
    public func localized(_ bundle: Bundle) -> String {
        NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
