//
//  StudyProgressView.swift
//  
//
//  Created by Caroline Taus on 04/10/22.
//

import SwiftUI
import HummingBird

public struct StudyProgressView: View {
    let numOfTotalSeen: Int
    let numOfTotalCards: Int
    let numOfReviewingSeen: Int
    let numOfReviewingCards: Int
    let numOfLearningSeen: Int
    let numOfLearningCards: Int
    let studyMode: StudyMode
    @Environment(\.dismiss) private var dismiss
    
    
    public init(numOfTotalSeen: Int, numOfTotalCards: Int, numOfReviewingSeen: Int, numOfReviewingCards: Int, numOfLearningSeen: Int, numOfLearningCards: Int, studyMode: StudyMode) {
        self.numOfTotalSeen = numOfTotalSeen
        self.numOfTotalCards = numOfTotalCards
        self.numOfReviewingSeen = numOfReviewingSeen
        self.numOfReviewingCards = numOfReviewingCards
        self.numOfLearningSeen = numOfLearningSeen
        self.numOfLearningCards = numOfLearningCards
        self.studyMode = studyMode
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    GraphView(title: NSLocalizedString("titulo_grafico_total", bundle: .module, comment: ""), numOfCardsSeen: numOfTotalSeen, numOfTotalCards: numOfTotalCards, color: HBColor.progressGraphTotal, backgroundColor: HBColor.progressGraphTotalBackground)
                        .frame(width: 250)
                        .padding()
                    
                    if numOfReviewingCards > 0 && studyMode == .spaced {
                        GraphView(title: NSLocalizedString("titulo_grafico_revisao", bundle: .module, comment: ""), numOfCardsSeen: numOfReviewingSeen, numOfTotalCards: numOfReviewingCards, color: HBColor.progressGraphReviewing, backgroundColor: HBColor.progressGraphReviewingBackground)
                            .frame(width: 250)
                            .padding()
                    }
                    
                    if numOfLearningCards > 0 && studyMode == .spaced {
                        GraphView(title: NSLocalizedString("titulo_grafico_aprendizado", bundle: .module, comment: ""), numOfCardsSeen: numOfLearningSeen, numOfTotalCards: numOfLearningCards, color: HBColor.progressGraphLearning, backgroundColor: HBColor.progressGraphLearningBackground)
                            .frame(width: 250)
                            .padding()
                    }
                }
                
                
            }
            .navigationTitle(NSLocalizedString("progress_view", bundle: .module, comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        dismiss()
                    }
                    .foregroundColor(HBColor.actionColor)
                }
            }
        }
    }
}

struct StudyProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StudyProgressView(numOfTotalSeen: 30, numOfTotalCards: 100, numOfReviewingSeen: 44, numOfReviewingCards: 90, numOfLearningSeen: 3, numOfLearningCards: 5, studyMode: .spaced)
    }
}


struct ProgressGraphBackground: View {
    var lineWidth: CGFloat = 16
    let backgroundColor: Color
    var body: some View {
        Circle()
            .stroke(backgroundColor,
                    style: StrokeStyle(lineWidth: lineWidth))
            .rotationEffect(.degrees(-90))
            .padding()
    }
}

struct ProgressGraph: View {
    let completedPercentage: CGFloat
    var lineWidth: CGFloat = 16
    let color: Color
    var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(completedPercentage) / 100)
            .stroke(color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    ))
            .rotationEffect(.degrees(-90))
            .padding()
    }
}

struct GraphView: View {
    let title: String
    let numOfCardsSeen: Int
    let numOfTotalCards: Int
    let color: Color
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .bold()
            ZStack {
                ProgressGraphBackground(backgroundColor: backgroundColor)
                ProgressGraph(completedPercentage: CGFloat(numOfCardsSeen * 100) / CGFloat(numOfTotalCards), color: color)
                VStack {
                    Text("\(numOfCardsSeen) " + NSLocalizedString("cartas_estudadas", bundle: .module, comment: ""))
                        .font(.title3)
                    Text(NSLocalizedString("de", bundle: .module, comment: "") + " \(numOfTotalCards) " + NSLocalizedString("cartas", bundle: .module, comment: ""))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
