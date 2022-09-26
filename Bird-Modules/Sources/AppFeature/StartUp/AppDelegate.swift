//
//  AppDelegate.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 26/09/22.
//

import SwiftUI
import Habitat

//swiftlint: disable discouraged_optional_collection

#if os(macOS)


#else
public final class AppDelegate: NSObject, UIApplicationDelegate {
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        setupHabitatForProduction()
        return true
    }
}

#endif