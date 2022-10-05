//
//  StudyProgressView.swift
//  
//
//  Created by Caroline Taus on 04/10/22.
//

import SwiftUI
import HummingBird

struct StudyProgressView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                GraphView(title: "Total da Sessão", numOfCardsSeen: 50, numOfTotalCards: 100, color: HBColor.progressGraphTotal)
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


struct ProgressGraphBackground: View {
    @State var lineWidth: CGFloat = 16
    var body: some View {
        Circle()
            .stroke(HBColor.progressGraphBackground,
                    style: StrokeStyle(lineWidth: lineWidth / 1.6))
            .rotationEffect(.degrees(-90))
            .padding(lineWidth/2)
    }
}

struct ProgressGraph: View {
    let completedPercentage: CGFloat
    @State var lineWidth: CGFloat = 16
    let color: Color
    var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(completedPercentage)/100)
            .stroke(color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    ))
            .rotationEffect(.degrees(-90))
            .padding(lineWidth/2)
    }
}

struct GraphView: View {
    let title: String
    let numOfCardsSeen: Int
    let numOfTotalCards: Int
    let color: Color
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .bold()
        HStack {
            ZStack {
                ProgressGraphBackground()
                ProgressGraph(completedPercentage: CGFloat(numOfCardsSeen * 100)/CGFloat(numOfTotalCards), color: color)
                VStack {
                    Text("\(numOfCardsSeen)")
                        .font(.title2)
                    Text("de \(numOfTotalCards) cartas")
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: 15)
                    Text("Estudados")
                }
                HStack {
                    Circle()
                        .fill(HBColor.progressGraphBackground)
                        .frame(width: 15)
                    Text("Restantes")
                }
                
            }
        }
        .padding()
    }
    
}
