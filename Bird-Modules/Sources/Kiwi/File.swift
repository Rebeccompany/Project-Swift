//
//  File.swift
//  
//
//  Created by Rebecca Mello on 12/12/22.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    public var numBaralhos: Int
    var body: some View {
        ZStack {
            VStack {
                Text("Baralhos Diários")
                Text("Dia da semana, DD/MM")
                
                
                if numBaralhos > 2 {
                    HStack {
                        Image(systemName: "ellipsis.circle")
                        Text("Mais \(numBaralhos) baralhos")
                    }
                }
            }
        }
    }
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(numBaralhos: 5)
    }
}
