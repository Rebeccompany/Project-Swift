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
    var action: () -> Void
    
    var body: some View {
        VStack {
            Text("atividade_concluida", bundle: .module)
                .bold()
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
                .padding()
            
            HBAssets.endOfStudy
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .accessibilityLabel(Text("arara_comemorando", bundle: .module))
            
            Text("atividade_concluida_text", bundle: .module)
                .foregroundColor(HBColor.collectionGray)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding()
            
            Button {
                action()
                dismiss()
            } label: {
                Text("go_back_to_deck", bundle: .module)
            }
            .buttonStyle(LargeButtonStyle(isDisabled: false, isFilled: false))
            .padding()
            
        }
    }
}

struct EndOfStudyView_Previews: PreviewProvider {
    static var previews: some View {
        EndOfStudyView {
            
        }
    }
}
