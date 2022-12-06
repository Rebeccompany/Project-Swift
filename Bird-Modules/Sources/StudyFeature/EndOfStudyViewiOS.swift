//
//  EndOfStudyViewiOS.swift
//  
//
//  Created by Rebecca Mello on 21/09/22.
//

import SwiftUI
import Storage
import Models
import HummingBird
import Utils

#if os(iOS)
struct EndOfStudyViewiOS: View {
    @Environment(\.dismiss) private var dismiss
    private let mode: StudyMode
    var action: () -> Void
    
    init(mode: StudyMode, action: @escaping () -> Void) {
        self.mode = mode
        self.action = action
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

struct EndOfStudyViewiOS_Previews: PreviewProvider {
    static var previews: some View {
        EndOfStudyViewiOS(mode: .spaced) { }
    }
}
#endif
