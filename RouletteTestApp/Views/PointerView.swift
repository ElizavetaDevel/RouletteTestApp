//
//  PointerView.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import SwiftUI

struct PointerView: View {
    var body: some View {
        return Triangle()
            .fill(Color.red)
            .frame(width: 20, height: 30)
            .offset(y: 0)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
