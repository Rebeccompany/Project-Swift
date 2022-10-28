//
//  File.swift
//  
//
//  Created by Marcos Chevis on 26/10/22.
//

import Foundation
import UIKit

#if !os(macOS)
extension UIImage {
    public func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
#endif
