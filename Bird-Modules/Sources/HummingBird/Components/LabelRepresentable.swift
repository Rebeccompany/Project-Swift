//
//  File.swift
//  
//
//  Created by Marcos Chevis on 26/10/22.
//

import Foundation
import SwiftUI

#if os(macOS)
import AppKit

public struct TextViewRepresentable: NSViewRepresentable {
    private var text: NSAttributedString
    
    public init(text: NSAttributedString) {
        self.text = text
    }
    
    func makeNSView(context: Context) -> NSTextField {
        var label = NSTextField()
        label.backgroundColor = .clear
        label.maximumNumberOfLines = 0
        label.isBezeled = false
        label.isEditable = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return label
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.attributedStringValue = text
    }
}

#else
import UIKit

public struct TextViewRepresentable: UIViewRepresentable {
    private var text: NSAttributedString
    
    public init(text: NSAttributedString) {
        self.text = text
    }

    public func makeUIView(context: Context) -> UITextView {
        let label = UITextView()
        label.isEditable = false
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return label
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
}

#endif
