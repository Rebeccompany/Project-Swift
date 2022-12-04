//
//  AuthenticationView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 23/11/22.
//

import HummingBird
import Habitat
import SwiftUI

public struct AuthenticationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    @ObservedObject private var model: AuthenticationModel
    
    public init(model: AuthenticationModel) {
        self.model = model
    }
    
    public var body: some View {
        NavigationStack(path: $path) {
            FillInfoView(model: model, path: $path) { dismiss() }
            //SignInView(model: model, path: $path) { dismiss() }
                .navigationDestination(for: AuthenticationRoute.self) { route in
                    switch route {
                    case .fillInfo:
                        FillInfoView(model: model, path: $path) { dismiss() }
                    }
                }
        }
        .onChange(of: model.user) { newValue in
            if newValue != nil {
                dismiss()
            }
        }
    }
}

enum AuthenticationRoute: Hashable {
    case fillInfo
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        HabitatPreview {
            AuthenticationView(model: .init())
        }
    }
}
