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
    @Environment(\.dismiss) private var dismiss
    private let mode: StudyMode
    var action: () -> Void
    
    init(mode: StudyMode, action: @escaping () -> Void) {
        self.mode = mode
        self.action = action
    }
    
    var body: some View {
        VStack {
            Text(mode == .spaced ? "Atividade diária concluída!" : "Estudo intenso concluído!")
                .bold()
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
                .padding()
            
            HBAssets.endOfStudy
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .accessibilityLabel(Text("Arara está comemorando com você"))
            
            Text(mode == .spaced ? "Parabéns, você cumpriu sua meta de estudos diária desse baralho! Volte em breve para continuar seus estudos!" : "Parabéns, você concluiu uma sessão de estudo intenso!")
                .foregroundColor(HBColor.collectionGray)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                action()
                dismiss()
            } label: {
                Text("Voltar para o Baralho")
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false, isFilled: false))
            .padding()
            
        }
    }
}

struct EndOfStudyView_Previews: PreviewProvider {
    static var previews: some View {
        EndOfStudyView(mode: .spaced) { }
    }
}
