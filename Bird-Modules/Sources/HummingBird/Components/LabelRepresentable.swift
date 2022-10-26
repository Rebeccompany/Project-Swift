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

struct LabelViewRepresentable: NSViewRepresentable {
    var text: NSAttributedString
    
    func makeNSView(context: Context) -> NSTextField {
        var label = NSTextField()
        label.backgroundColor = .clear
        label.isBezeled = false
        label.isEditable = false
        
        return label
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.attributedStringValue = text
    }
}

#else
import UIKit

struct LabelViewRepresentable: UIViewRepresentable {
    var text: NSAttributedString

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = text
    }
}

#endif
