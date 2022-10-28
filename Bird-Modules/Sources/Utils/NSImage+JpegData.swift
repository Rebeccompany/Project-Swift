//
//  NSImage+JpegData.swift
//  
//
//  Created by Nathalia do Valle Papst on 28/10/22.
//

#if canImport(AppKit)
import AppKit

extension NSImage {

    public var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }

    public func jpegData(compressionQuality: CGFloat) -> Data? {
        guard let image = cgImage else { return nil }
        let bitmap = NSBitmapImageRep(cgImage: image)
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
    }
}
#endif
