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
import RichTextKit
public struct TextViewRepresentable: NSViewRepresentable {
    private var text: NSAttributedString

    public init(text: NSAttributedString) {
        self.text = text
    }

    public func makeNSView(context: Context) -> RichTextView {
        let label = RichTextView.scrollableTextView().documentView as? RichTextView ?? RichTextView()
        
        label.attributedString = text
        label.backgroundColor = .clear
        label.isEditable = false
        label.isSelectable = false
        
        

        return label
    }

    public func updateNSView(_ nsView: RichTextView, context: Context) {
        nsView.attributedString = text
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
