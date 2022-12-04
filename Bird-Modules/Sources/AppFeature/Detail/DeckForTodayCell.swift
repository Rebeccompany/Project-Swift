//
//  DeckForTodayCell.swift
//  
//
//  Created by Caroline Taus on 19/10/22.
//

import SwiftUI
import HummingBird
import Models


struct DeckForTodayCell: View {
    var deck: Deck
    var view: DetailDisplayType
    
    var body: some View {
        if view == .grid {
            HStack {
                IconCircleView(iconName: deck.icon)
                    .padding(.vertical, 4)
                VStack(alignment: .leading) {
                    Text(deck.name)
                        .font(.title3)
                        .bold()
                    
                    let cardsForToday = deck.session?.cardIds.count ?? 404
                    
                    Text(String.localizedStringWithFormat(NSLocalizedString("%d cartas_hoje", bundle: .module, comment: ""), cardsForToday))
                        .font(.subheadline)
                }
                .foregroundColor(Color.white)
                Spacer()
            }
            .padding(.horizontal)
            #if os(iOS)
            .frame(width: 250, height: 80)
            #elseif os(macOS)
            .frame(width: 250, height: 80 * 0.6)
            #endif
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(HBColor.color(for: deck.color))
            }
        } else {
            #if os(macOS)
            HStack {
                Image(systemName: deck.icon)
                    .foregroundColor(HBColor.color(for: deck.color))
                Text(deck.name)
                    .foregroundColor(HBColor.color(for: deck.color))
            }
            .padding(5)
            .padding(.horizontal, 6)
            .background {
                RoundedRectangle(cornerRadius: 30)
                    .fill(HBColor.color(for: deck.color).opacity(0.2))
            }
            #elseif os(iOS)
            Label(deck.name, systemImage: deck.icon)
            #endif
        }
    }
    
}

private struct IconCircleView: View {
    let angle: [Angle] = [Angle(degrees: 180), Angle(degrees: 300), Angle(degrees: 60)]
    let opacity: [Double] = [0.5, 0.7, 0.3]
    let iconName: String
    
#if os(macOS)
    let radius = 20 * 0.65
#elseif os(iOS)
    let radius = 20
#endif
    
    var body: some View {
        IconCircle(radius: CGFloat(radius), angle: 90) {
            ForEach(0..<3) { icon in
                Image(systemName: iconName)
                    .foregroundColor(Color.white)
                #if os(macOS)
                    .font(.body)
                #elseif os(iOS)
                    .font(.title2)
                #endif
                    .opacity(opacity[icon])
                    .rotationEffect(angle[icon])
            }
        }
    }
}

private struct IconCircle: Layout {
    let radius: CGFloat
    let angle: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxSize = subviews.map { $0.sizeThatFits(proposal) }.reduce(CGSize.zero) {
            CGSize(width: max($0.width, $1.width), height: max($0.height, $1.height))
        }
        
        return CGSize(width: (maxSize.width / 2 + radius) * 2,
                      height: (maxSize.height / 2 + radius) * 2)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for (index, subview) in subviews.enumerated() {
            var point = CGPoint(x: 0, y: -radius)
                .applying(CGAffineTransform(
                    rotationAngle: angle * Double(index)))
            
            point.x += bounds.midX
            point.y += bounds.midY
            
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}

struct DeckForTodayCell_Previews: PreviewProvider {
    static var previews: some View {
        DeckForTodayCell(deck: Deck(id: UUID(), name: "Palavras em Inglês", icon: "flame", color: CollectionColor.darkPurple, datesLogs: DateLogs(), collectionId: nil, cardsIds: [], spacedRepetitionConfig: .init(), session: Session(cardIds: [UUID(), UUID()], date: Date(), deckId: UUID(), id: UUID()), category: .others, storeId: nil, description: "", ownerId: nil))
            .frame(width: 300, height: 100)
            .previewLayout(.sizeThatFits)
            .viewBackgroundColor(Color.blue)
    }
}
