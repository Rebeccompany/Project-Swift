//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 24/10/22.
//

import SwiftUI
import Models

public struct HBColorPicker<Label: View>: View {
    @State private var _color: Color = .black
    @State private var present = false
    private var labelBuilder: () -> Label
    private var onColorSelected: (Color) -> Void
    
    public init(@ViewBuilder label: @escaping () -> Label, onColorSelected: @escaping (Color) -> Void) {
        self.labelBuilder = label
        self.onColorSelected = onColorSelected
    }
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    #endif
    
    private let colors: [Color] = {
        var colors = CollectionColor.allCases.map(HBColor.color(for:))
        colors.insert(HBColor.black, at: 0)
        colors.insert(HBColor.white, at: 0)
        colors.insert(HBColor.clear, at: 0)
        return colors
    }()
    
    public var body: some View {
        Button {
            present = true
        } label: {
            VStack {
                labelBuilder()
                _color
                    .frame(width: 17, height: 4)
            }
            .font(.body)
            .frame(width: 18, height: 18)
        }
        #if os(iOS)
        .buttonStyle(.bordered)
        #endif
        .popover(isPresented: $present) {
            colorGrid
                .frame(minWidth: 180, maxWidth: 350, minHeight: 160, maxHeight: 350)
        }
        .presentationDetents([.height(180)])
    }
    
    @ViewBuilder
    private var colorGrid: some View {
        VStack {
            #if os(iOS)
            if horizontalSizeClass == .compact {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 6)
                    .padding(.top, 8)
            }
            #endif
            
            ScrollView(.horizontal, showsIndicators: true) {
                LazyHGrid(rows: [GridItem(.adaptive(minimum: 44))]) {
                    ForEach(colors, id: \.self) { color in
                        Button {
                            onColorSelected(color)
                            _color = color
                        } label: {
                            color
                                .clipShape(Circle())
                                .padding(4)
                                .overlay {
                                    ZStack {
                                        if color == .clear {
                                            Path { path in
                                                path.move(to: CGPoint(x: 100, y: 100))
                                                path.addLine(to: CGPoint.zero)
                                            }
                                            .stroke(.red, lineWidth: 8)
                                        }
                                        Circle()
                                            .stroke(_color == color ? HBColor.actionColor : Color.gray,
                                                    lineWidth: color == _color ? 4 : 2)
                                    }
                                }
                                #if os(iOS)
                                .frame(width: 56, height: 56)
                                #elseif os(macOS)
                                .frame(width: 35, height: 35)
                                #endif
                                .clipShape(Circle())
                            
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .background(HBColor.primaryBackground)
    }
}

struct HBColorPicker_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            HBColorPicker {
                Image(systemName: "character")
                    .font(.system(size: 18))
            } onColorSelected: { _ in
                 
            }
            HBColorPicker {
                Image(systemName: "highlighter")
                    .font(.system(size: 14))
            } onColorSelected: { _ in
                 
            }
        }
    }
}
