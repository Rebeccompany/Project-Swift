//
//  Card+CardEntity.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/08/22.
//
import Foundation
import SwiftUI

extension Data {
    public func toRtfd() -> NSAttributedString? {
        try? NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.rtfd], documentAttributes: nil)
    }
    
    public func toRtf() -> NSAttributedString? {
        try? NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
    }
}

extension NSAttributedString {
    public func rtfdData() -> Data? {
        try? data(from: .init(location: 0, length: length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
    }
}
