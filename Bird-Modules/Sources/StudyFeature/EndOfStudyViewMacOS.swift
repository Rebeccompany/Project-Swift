//
//  EndOfStudyViewMacOS.swift
//  
//
//  Created by Nathalia do Valle Papst on 10/11/22.
//

import SwiftUI
import Storage
import Models
import HummingBird
import Utils

#if os(macOS)
struct EndOfStudyViewMacOS: View {
    private let mode: StudyMode
    
    init(mode: StudyMode) {
        self.mode = mode
    }
    
    var body: some View {
        VStack {
            Text(mode == .spaced ? NSLocalizedString("atividade_concluida", bundle: .module, comment: "") : NSLocalizedString("intenso_concluido", bundle: .module, comment: ""))
                .bold()
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            
            HBAssets.endOfStudy
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .accessibilityLabel(Text("arara_comemorando", bundle: .module))
            
            Text(mode == .spaced ? NSLocalizedString("atividade_concluida_text", bundle: .module, comment: "") : NSLocalizedString("intenso_concluido_text", bundle: .module, comment: ""))
                .foregroundColor(HBColor.collectionGray)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding()
            
            Text(NSLocalizedString("fechar_janela", bundle: .module, comment: ""))
                .font(.system(size: 18, weight: .bold))
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}

struct EndOfStudyViewMacvOS_Previews: PreviewProvider {
    static var previews: some View {
        EndOfStudyViewMacOS(mode: .spaced)
    }
}
#endif
