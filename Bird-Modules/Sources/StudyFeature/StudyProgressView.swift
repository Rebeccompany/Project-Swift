//
//  StudyProgressView.swift
//  
//
//  Created by Caroline Taus on 04/10/22.
//

import SwiftUI

struct StudyProgressView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Total da Sessão")
                        .font(.subheadline)
                        .bold()
                    HStack {
                        Text("graficozinho 1")
                        Spacer()
                        VStack {
                            HStack {
                                Circle()
                                    .frame(width: 20)
                                Text("legendinha")
                            }
                            
                        }
                    }
                    .padding()
                    
                }
                .padding()
            }
            .navigationTitle("Progresso da Sessão")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        print("dismiss")
                    }
                }
            }
        }
    }
}

struct StudyProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StudyProgressView()
    }
}
