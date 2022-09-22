//
//  EndOfStudyView.swift
//  
//
//  Created by Rebecca Mello on 21/09/22.
//

import SwiftUI
import Storage
import Models
import HummingBird
import Utils

struct EndOfStudyView: View {
    var body: some View {
        VStack {
            Text("Atividade diária concluída!")
                .bold()
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Parabéns, você cumpriu sua meta de estudos diária desse baralho! Volte em breve para continuar seus estudos!")
                .foregroundColor(HBColor.collectionGray)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding()
            
            Button{
                #warning("ir pra tela do baralho")
            } label: {
                Text("Voltar para o Baralho")
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false))
            .padding()
            
        }
    }
}

struct EndOfStudyView_Previews: PreviewProvider {
    static var previews: some View {
        EndOfStudyView()
    }
}
