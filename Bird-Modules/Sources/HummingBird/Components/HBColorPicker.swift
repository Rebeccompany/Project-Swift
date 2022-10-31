//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 24/10/22.
//

import SwiftUI
import Models

public struct HBColorPicker<Label: View>: View {
    @Binding var selection: Color
    @State private var _color: Color = .white
    @State private var present = false
    private var labelBuilder: () -> Label
    
    public init(selection: Binding<Color>, @ViewBuilder label: @escaping () -> Label) {
        self._selection = selection
        self.labelBuilder = label
    }
    
    
#if os(iOS)
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
#endif
    
    private let colors: [Color] = {
        var colors = CollectionColor.allCases.map(HBColor.color(for:))
        colors.insert(HBColor.black, at: 0)
        colors.insert(HBColor.white, at: 0)
        return colors
    }()
    
    public var body: some View {
        Button {
            present = true
        } label: {
            VStack {
                labelBuilder()
                selection
                    .frame(width: 17, height: 4)
            }
            .font(.body)
            .frame(width: 18, height: 18)
        }
        .buttonStyle(.bordered)
        .onAppear {
            _color = selection
        }
        .popover(isPresented: $present) {
            colorGrid
                .frame(minWidth: 180, minHeight: 160)
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
                            selection = color
                            _color = color
                        } label: {
                            color
                                .clipShape(Circle())
                                .padding(4)
                                .overlay {
                                    Circle()
                                        .stroke(_color == color ? HBColor.actionColor : Color.gray, lineWidth: color == _color ? 4 : 2)
                                }
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                        }
                    }
                }.padding()
            }
        }
        .background(HBColor.primaryBackground)
    }
}

struct HBColorPicker_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            HBColorPicker(selection: .constant(HBColor.collectionRed)) {
                Image(systemName: "character")
                    .font(.system(size: 18))
            }
            HBColorPicker(selection: .constant(HBColor.collectionRed)) {
                Image(systemName: "highlighter")
                    .font(.system(size: 14))
            }
        }
    }
}
