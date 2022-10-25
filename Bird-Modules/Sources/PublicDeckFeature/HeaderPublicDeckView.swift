//
//  HeaderPublicDeckView.swift
//  
//
//  Created by Rebecca Mello on 25/10/22.
//

import SwiftUI

struct HeaderPublicDeckView: View {
    var body: some View {
        Image(systemName: "chevron.down")
            .font(.system(size: 40))
            .foregroundColor(.white)
            .padding()
            .background(
                Circle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
            )
        
        Text("Nomeeeee do baralho")
            .font(.title2)
            .bold()
            .padding(.top, 20)
        
        Text("AUTOOOOR")
    }
}

struct HeaderPublicDeckView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderPublicDeckView()
    }
}
