//
//  File.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 24/10/22.
//

import SwiftUI
import Models

struct HBColorPicker: View {
    var systemImage: String
    @Binding var selection: Color
    @State var present = false
    
#if os(iOS)
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
#endif
    
    private let colors: [Color] = {
        var colors = CollectionColor.allCases.map(HBColor.color(for:))
        colors.insert(.black, at: 0)
        colors.insert(.white, at: 0)
        return colors
    }()
    
    var body: some View {
        Button {
            present = true
        } label: {
            VStack {
                Image(systemName: systemImage)
                selection
                    .frame(width: 17, height: 5)
            }
            .font(.body)
        }
        .buttonStyle(.bordered)
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
                        Button { selection = color } label: {
                            color
                                .clipShape(Circle())
                                .padding(4)
                                .overlay {
                                    Circle()
                                        .stroke(color == selection ? HBColor.actionColor : Color.gray, lineWidth: color == selection ? 4 : 2)
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
            HBColorPicker(systemImage: "character", selection: .constant(HBColor.collectionRed))
        }
    }
}
