//
//  File.swift
//  
//
//  Created by Claudia Fiorentino on 17/11/22.
//

import Foundation
import SwiftUI

struct SpixiiShapeBack: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.37349 * width, y: 0))
        path.addCurve(to: CGPoint(x: 0.35449 * width, y: 0.14918 * height), control1: CGPoint(x: 0.34706 * width, y: 0.0414 * height), control2: CGPoint(x: 0.33464 * width, y: 0.09182 * height))
        path.addCurve(to: CGPoint(x: 0.40374 * width, y: 0.23286 * height), control1: CGPoint(x: 0.36328 * width, y: 0.17557 * height), control2: CGPoint(x: 0.37904 * width, y: 0.20348 * height))
        path.addLine(to: CGPoint(x: 0.4046 * width, y: 0.23308 * height))
        path.addCurve(to: CGPoint(x: 0.40546 * width, y: 0.23328 * height), control1: CGPoint(x: 0.40479 * width, y: 0.23327 * height), control2: CGPoint(x: 0.40514 * width, y: 0.23336 * height))
        path.addCurve(to: CGPoint(x: 0.43696 * width, y: 0.14392 * height), control1: CGPoint(x: 0.39329 * width, y: 0.21176 * height), control2: CGPoint(x: 0.392 * width, y: 0.17697 * height))
        path.addCurve(to: CGPoint(x: 0.43758 * width, y: 0.14347 * height), control1: CGPoint(x: 0.43716 * width, y: 0.14377 * height), control2: CGPoint(x: 0.43737 * width, y: 0.14362 * height))
        path.addCurve(to: CGPoint(x: 0.60113 * width, y: 0.12564 * height), control1: CGPoint(x: 0.491 * width, y: 0.10458 * height), control2: CGPoint(x: 0.55718 * width, y: 0.10805 * height))
        path.addCurve(to: CGPoint(x: 0.62613 * width, y: 0.13872 * height), control1: CGPoint(x: 0.61062 * width, y: 0.12944 * height), control2: CGPoint(x: 0.61906 * width, y: 0.13389 * height))
        path.addCurve(to: CGPoint(x: 0.66349 * width, y: 0.234 * height), control1: CGPoint(x: 0.66683 * width, y: 0.16588 * height), control2: CGPoint(x: 0.67646 * width, y: 0.19895 * height))
        path.addCurve(to: CGPoint(x: 0.42902 * width, y: 0.28331 * height), control1: CGPoint(x: 0.65052 * width, y: 0.26905 * height), control2: CGPoint(x: 0.58727 * width, y: 0.32066 * height))
        path.addCurve(to: CGPoint(x: 0.42893 * width, y: 0.28344 * height), control1: CGPoint(x: 0.42902 * width, y: 0.28331 * height), control2: CGPoint(x: 0.42895 * width, y: 0.28334 * height))
        path.addCurve(to: CGPoint(x: 0.4202 * width, y: 0.28168 * height), control1: CGPoint(x: 0.42295 * width, y: 0.28206 * height), control2: CGPoint(x: 0.4202 * width, y: 0.28168 * height))
        path.addCurve(to: CGPoint(x: 0, y: 0.29857 * height), control1: CGPoint(x: 0.26369 * width, y: 0.24474 * height), control2: CGPoint(x: 0.10833 * width, y: 0.26904 * height))
        path.addLine(to: CGPoint(x: 0, y: 0.95028 * height))
        path.addCurve(to: CGPoint(x: 0.0701 * width, y: 0.99913 * height), control1: CGPoint(x: 0, y: 0.97726 * height), control2: CGPoint(x: 0.03139 * width, y: 0.99913 * height))
        path.addLine(to: CGPoint(x: 0.60321 * width, y: 0.99913 * height))
        path.addCurve(to: CGPoint(x: 0.74668 * width, y: 0.88861 * height), control1: CGPoint(x: 0.65347 * width, y: 0.97066 * height), control2: CGPoint(x: 0.70171 * width, y: 0.93424 * height))
        path.addCurve(to: CGPoint(x: 0.48283 * width, y: 0.94817 * height), control1: CGPoint(x: 0.70432 * width, y: 0.92538 * height), control2: CGPoint(x: 0.62116 * width, y: 0.98857 * height))
        path.addCurve(to: CGPoint(x: 0.35892 * width, y: 0.7344 * height), control1: CGPoint(x: 0.40634 * width, y: 0.92628 * height), control2: CGPoint(x: 0.27447 * width, y: 0.85288 * height))
        path.addCurve(to: CGPoint(x: 0.65494 * width, y: 0.62915 * height), control1: CGPoint(x: 0.38281 * width, y: 0.69882 * height), control2: CGPoint(x: 0.44469 * width, y: 0.62966 * height))
        path.addCurve(to: CGPoint(x: 0.99983 * width, y: 0.51861 * height), control1: CGPoint(x: 0.77626 * width, y: 0.62885 * height), control2: CGPoint(x: 0.90244 * width, y: 0.5868 * height))
        path.addLine(to: CGPoint(x: 0.99983 * width, y: 0.04885 * height))
        path.addCurve(to: CGPoint(x: 0.92973 * width, y: 0), control1: CGPoint(x: 0.99983 * width, y: 0.02187 * height), control2: CGPoint(x: 0.96845 * width, y: 0))
        path.addLine(to: CGPoint(x: 0.37349 * width, y: 0))
        path.closeSubpath()
        return path
    }
}


struct SpixiiShapeFront: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.62634 * width, y: 0))
        path.addCurve(to: CGPoint(x: 0.64535 * width, y: 0.14918 * height), control1: CGPoint(x: 0.65278 * width, y: 0.0414 * height), control2: CGPoint(x: 0.66519 * width, y: 0.09182 * height))
        path.addCurve(to: CGPoint(x: 0.59609 * width, y: 0.23286 * height), control1: CGPoint(x: 0.63656 * width, y: 0.17557 * height), control2: CGPoint(x: 0.6208 * width, y: 0.20348 * height))
        path.addLine(to: CGPoint(x: 0.59523 * width, y: 0.23308 * height))
        path.addCurve(to: CGPoint(x: 0.59438 * width, y: 0.23328 * height), control1: CGPoint(x: 0.59504 * width, y: 0.23327 * height), control2: CGPoint(x: 0.59469 * width, y: 0.23336 * height))
        path.addCurve(to: CGPoint(x: 0.56288 * width, y: 0.14392 * height), control1: CGPoint(x: 0.60654 * width, y: 0.21176 * height), control2: CGPoint(x: 0.60783 * width, y: 0.17697 * height))
        path.addCurve(to: CGPoint(x: 0.56226 * width, y: 0.14347 * height), control1: CGPoint(x: 0.56267 * width, y: 0.14377 * height), control2: CGPoint(x: 0.56246 * width, y: 0.14362 * height))
        path.addCurve(to: CGPoint(x: 0.3987 * width, y: 0.12564 * height), control1: CGPoint(x: 0.50884 * width, y: 0.10458 * height), control2: CGPoint(x: 0.44266 * width, y: 0.10805 * height))
        path.addCurve(to: CGPoint(x: 0.37371 * width, y: 0.13872 * height), control1: CGPoint(x: 0.38922 * width, y: 0.12944 * height), control2: CGPoint(x: 0.38077 * width, y: 0.13389 * height))
        path.addCurve(to: CGPoint(x: 0.33634 * width, y: 0.234 * height), control1: CGPoint(x: 0.333 * width, y: 0.16588 * height), control2: CGPoint(x: 0.32337 * width, y: 0.19895 * height))
        path.addCurve(to: CGPoint(x: 0.57081 * width, y: 0.28331 * height), control1: CGPoint(x: 0.34931 * width, y: 0.26905 * height), control2: CGPoint(x: 0.41256 * width, y: 0.32066 * height))
        path.addCurve(to: CGPoint(x: 0.57091 * width, y: 0.28344 * height), control1: CGPoint(x: 0.57081 * width, y: 0.28331 * height), control2: CGPoint(x: 0.57089 * width, y: 0.28334 * height))
        path.addCurve(to: CGPoint(x: 0.57964 * width, y: 0.28168 * height), control1: CGPoint(x: 0.57688 * width, y: 0.28206 * height), control2: CGPoint(x: 0.57964 * width, y: 0.28168 * height))
        path.addCurve(to: CGPoint(x: 0.99983 * width, y: 0.29857 * height), control1: CGPoint(x: 0.73615 * width, y: 0.24474 * height), control2: CGPoint(x: 0.8915 * width, y: 0.26904 * height))
        path.addLine(to: CGPoint(x: 0.99983 * width, y: 0.95028 * height))
        path.addCurve(to: CGPoint(x: 0.92973 * width, y: 0.99913 * height), control1: CGPoint(x: 0.99983 * width, y: 0.97726 * height), control2: CGPoint(x: 0.96845 * width, y: 0.99913 * height))
        path.addLine(to: CGPoint(x: 0.39663 * width, y: 0.99913 * height))
        path.addCurve(to: CGPoint(x: 0.25316 * width, y: 0.88861 * height), control1: CGPoint(x: 0.34637 * width, y: 0.97066 * height), control2: CGPoint(x: 0.29812 * width, y: 0.93424 * height))
        path.addCurve(to: CGPoint(x: 0.51701 * width, y: 0.94817 * height), control1: CGPoint(x: 0.29551 * width, y: 0.92538 * height), control2: CGPoint(x: 0.37868 * width, y: 0.98857 * height))
        path.addCurve(to: CGPoint(x: 0.64092 * width, y: 0.7344 * height), control1: CGPoint(x: 0.5935 * width, y: 0.92628 * height), control2: CGPoint(x: 0.72537 * width, y: 0.85288 * height))
        path.addCurve(to: CGPoint(x: 0.3449 * width, y: 0.62915 * height), control1: CGPoint(x: 0.61703 * width, y: 0.69882 * height), control2: CGPoint(x: 0.55514 * width, y: 0.62966 * height))
        path.addCurve(to: CGPoint(x: 0, y: 0.51861 * height), control1: CGPoint(x: 0.22358 * width, y: 0.62885 * height), control2: CGPoint(x: 0.0974 * width, y: 0.5868 * height))
        path.addLine(to: CGPoint(x: 0, y: 0.04885 * height))
        path.addCurve(to: CGPoint(x: 0.0701 * width, y: 0), control1: CGPoint(x: 0, y: 0.02187 * height), control2: CGPoint(x: 0.03139 * width, y: 0))
        path.addLine(to: CGPoint(x: 0.62634 * width, y: 0))
        path.closeSubpath()
        return path
    }
}
