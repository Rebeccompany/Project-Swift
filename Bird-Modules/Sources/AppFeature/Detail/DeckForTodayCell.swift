//
//  DeckForTodayCell.swift
//  
//
//  Created by Caroline Taus on 19/10/22.
//

import SwiftUI

struct DeckForTodayCell: View {
    var body: some View {
        VStack {
            IconCircle(radius: 80, angle: 90, offset: 5) {
                ForEach(0..<3) { idx in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red)
                                    .frame(width: 70, height: 70)
                                    }
            }
        }
    }
}

struct DeckForTodayCell_Previews: PreviewProvider {
    static var previews: some View {
        DeckForTodayCell()
    }
}

struct IconCircle: Layout {
    let radius: CGFloat
    let angle: CGFloat
    let offset: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for (index, subview) in subviews.enumerated() {
            // Find a vector with an appropriate size and rotation.
            var point = CGPoint(x: 0, y: -radius)
                .applying(CGAffineTransform(
                    rotationAngle: angle * Double(index) + offset))

            // Shift the vector to the middle of the region.
            point.x += bounds.midX
            point.y += bounds.midY

            // Place the subview.
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
    
    
}
