//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 30/11/22.
//

import Foundation

public enum DeepLinkURL {
    public static func url(path: String) -> URL {
        guard
            let url = URL(string: "spixii://\(path)")
        else { preconditionFailure("Invalid URL") }
        
        return url
    }
}
