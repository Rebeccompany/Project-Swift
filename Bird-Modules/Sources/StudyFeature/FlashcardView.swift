//
//  FlashcardView.swift
//  
//
//  Created by Gabriel Ferreira de Carvalho on 02/09/22.
//

import SwiftUI
import Models
import HummingBird

struct FlashcardView: View {
    @Binding var viewModel: CardViewModel
    var index: Int
    var cardCount: Int
    @State private var frontDegree: Double = 0
    @State private var backDegree: Double = -90
    
    init(viewModel: Binding<CardViewModel>, index: Int, cardCount: Int) {
        self._viewModel = viewModel
        self.index = index
        self.cardCount = cardCount
    }
    
    var body: some View {
        ZStack {
            cardFace(content: viewModel.card.back, face: NSLocalizedString("verso", bundle: .module, comment: ""), description: "arrow.triangle.2.circlepath")
                .rotation3DEffect(.degrees(backDegree), axis: (x: 0, y: 1, z: 0.0001))
            cardFace(content: viewModel.card.front, face: NSLocalizedString("frente", bundle: .module, comment: ""), description: "arrow.triangle.2.circlepath")
                .rotation3DEffect(.degrees(frontDegree), axis: (x: 0, y: 1, z: 0.0001))
        }
        .shadow(color: .black.opacity(0.3), radius: 1, y: -1)
        .onTapGesture(perform: flip)
        .onChange(of: viewModel.isFlipped) { newValue in
            flipWithAnimation(newValue)
        }
        .transaction { transaction in
            if index == 0 && !viewModel.isFlipped && cardCount > 1 {
                transaction.animation = nil
            }
        }
        
    }
    
    private func flip() {
        
        if index != 0 || cardCount <= 1 {
            viewModel.isFlipped.toggle()
        }
        
    }
    
    private func flipWithoutAnimation(_ newValue: Bool) {
        if newValue {
            frontDegree = 90
            backDegree = 0
        } else {
            backDegree = -90
            frontDegree = 0
        }
    }
    
    private func flipWithAnimation(_ newValue: Bool) {
        let animDuration: Double = 0.25
        if newValue {
            withAnimation(.linear(duration: animDuration)) {
                frontDegree = 90
            }
            
            withAnimation(.linear(duration: animDuration).delay(animDuration)) {
                backDegree = 0
            }
        } else {
            withAnimation(.linear(duration: animDuration)) {
                backDegree = -90
            }
            
            withAnimation(.linear(duration: animDuration).delay(animDuration)) {
                frontDegree = 0
            }
        }
    }
    
    @ViewBuilder
    private func cardFace(content: NSAttributedString, face: String, description: String) -> some View {
        VStack {
            HStack {
                Text(face)
                    .font(.system(size: 15))
                Spacer()
            }
            
            Spacer()
            #if os(iOS)
            TextViewRepresentable(text: content)
                .minimumScaleFactor(0.01)
            #elseif os(macOS)
            ScrollView {
                Text(AttributedString(content))
            }
            #endif
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: description)
                    .font(.system(size: 30))
            }
        }
        .foregroundColor(viewModel.card.color == CollectionColor.white ? .black : .white)
        .padding(24)
        .background {
            if content == viewModel.card.front {
                SpixiiShapeFront()
                    .foregroundColor(HBColor.color(for: viewModel.card.color))
            } else {
                SpixiiShapeBack()
                    .foregroundColor(HBColor.color(for: viewModel.card.color))
                    .brightness(0.04)
            }
        }
        .background {
            if content == viewModel.card.front {
                HBColor.color(for: viewModel.card.color).brightness(0.04)
            } else {
                HBColor.color(for: viewModel.card.color)
            }
        }
        .cornerRadius(24)

    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var dummy: Card {
        let id = UUID()
        let deckId = UUID(uuidString: "25804f37-a401-4211-b8d1-ac2d3de53775")!
        let frontData = "Toxoplasmose: exame e seus respectivo tempo e tratamento".data(using: .utf8)!
        let backData = ". Sorologia (IgM,IgG) -&gt; Teste de Avidez (&lt;30% aguda, &gt;60% cronica)&nbsp;<br>. Espiramicina 3g -VO 2 cp de 500mg por 8/8h&nbsp;".data(using: .utf8)!
        
        let frontNSAttributedString = try! NSAttributedString(data: frontData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let backNSAttributedString = try! NSAttributedString(data: backData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        let wp = WoodpeckerCardInfo(step: 1,
                                    isGraduated: true,
                                    easeFactor: 2.5,
                                    streak: 1,
                                    interval: 1,
                                    hasBeenPresented: true)
        
        return Card(id: id, front: frontNSAttributedString, back: backNSAttributedString, color: .red, datesLogs: dateLog, deckID: deckId, woodpeckerCardInfo: wp, history: [])
    }
    
    static var previews: some View {
        FlashcardView(viewModel: .constant(CardViewModel(card: dummy, isFlipped: false)), index: 0, cardCount: 2)
            .frame(width: 340, height: 480)
            .padding()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}
