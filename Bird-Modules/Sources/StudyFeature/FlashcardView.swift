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
    var card: Card
    @State private var isFlipped: Bool = false
    @State private var frontDegree: Double = 0
    @State private var backDegree: Double = -90
    
    var body: some View {
        ZStack {
            cardFace(content: card.back, face: "Verso", description: "Toque para ver a frente")
                .rotation3DEffect(.degrees(backDegree), axis: (x: 0, y: 1, z: 0))
            cardFace(content: card.front, face: "Frente", description: "Toque para ver o verso")
                .rotation3DEffect(.degrees(frontDegree), axis: (x: 0, y: 1, z: 0))
        }
        .onTapGesture(perform: flip)
        
    }
    
    private func flip() {
        isFlipped.toggle()
        let animDuration: Double = 0.25
        
        if isFlipped {
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
    
    private func prepareAttrStringToDisplay(_ attr: AttributedString) -> AttributedString {
        var attr = attr
        attr.swiftUI.font = .body
        attr.swiftUI.foregroundColor = .white
        return attr
    }
    
    @ViewBuilder
    private func cardFace(content: AttributedString, face: String, description: String) -> some View {
        VStack {
            HStack {
                Text(face)
                    .font(.system(size: 15))
                Spacer()
            }
            
            Spacer()
            Text(prepareAttrStringToDisplay(content))
                .minimumScaleFactor(0.01)
            Spacer()
            
            HStack {
                Spacer()
                Text(description)
                    .font(.system(size: 15))
            }
        }
        .foregroundColor(.white)
        .padding(24)
        .background(HBColor.getHBColrFromCollectionColor(card.color))
        .cornerRadius(24)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white, lineWidth: 3)
        )
    }
}

struct FlashcardView_Previews: PreviewProvider {
    static var dummy: Card {
        let id = UUID()
        let deckId = UUID(uuidString: "25804f37-a401-4211-b8d1-ac2d3de53775")!
        let frontData = "Toxoplasmose: exame e seus respectivo tempo e tratamento".data(using: .utf8)!
        let backData =  ". Sorologia (IgM,IgG) -&gt; Teste de Avidez (&lt;30% aguda, &gt;60% cronica)&nbsp;<br>. Espiramicina 3g -VO 2 cp de 500mg por 8/8h&nbsp;".data(using: .utf8)!
        
        let frontNSAttributedString = try! NSAttributedString(data: frontData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let backNSAttributedString = try! NSAttributedString(data: backData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let dateLog = DateLogs(lastAccess: Date(timeIntervalSince1970: 0),
                               lastEdit: Date(timeIntervalSince1970: 0),
                               createdAt: Date(timeIntervalSince1970: 0))
        let wp = WoodpeckerCardInfo(step: 1,
                                    isGraduated: true,
                                    easeFactor: 2.5,
                                    streak: 1,
                                    interval: 1, hasBeenPresented: true)
        
        return Card(id: id, front: AttributedString(frontNSAttributedString), back: AttributedString(backNSAttributedString), color: .beigeBrown, datesLogs: dateLog, deckID: deckId, woodpeckerCardInfo: wp, history: [])
    }
    
    static var previews: some View {
        FlashcardView(card: dummy)
            .frame(width: 340, height: 480)
            .padding()
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}