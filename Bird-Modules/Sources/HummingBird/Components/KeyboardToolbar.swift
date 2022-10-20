//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 19/10/22.
//

#if os(iOS)
import SwiftUI
import Foundation
import Combine

struct KeyboardToolbar<ToolbarView: View>: ViewModifier {
    
    @State private var height: CGFloat = 0
    private let toolbarView: ToolbarView
    @State private var showContent = false
    
    init(@ViewBuilder toolbar: () -> ToolbarView) {
        self.toolbarView = toolbar()
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            VStack {
                GeometryReader { proxy in
                    VStack {
                        content
                    }.frame(width: proxy.size.width, height: proxy.size.height - height)
                }
                
                if showContent {
                    toolbarView
                        .background {
                            GeometryReader { backgroundProxy in
                                Color.clear
                                    .onChange(of: backgroundProxy.size.height) { newValue in
                                        height = newValue
                                    }
                            }
                        }
                        .animation(.linear, value: showContent)
                }
            }
        }
        .onReceive(Publishers.keyboardRect) { newValue in
            if newValue == true {
                showContent = true
            } else {
                showContent = false
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension Publishers {
    fileprivate static var keyboardRect: AnyPublisher<Bool, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { _ in true }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in false }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}



extension Notification {
    fileprivate var keyboardRect: CGRect {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero
    }
}

extension View {
    public func keyboardToolbar<ToolbarView>(@ViewBuilder view:  @escaping  () -> ToolbarView) -> some View where ToolbarView: View {
        modifier(KeyboardToolbar(toolbar: view))
    }
}
#endif
