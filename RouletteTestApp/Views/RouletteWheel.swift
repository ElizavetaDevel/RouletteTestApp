//
//  RouletteWheel.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import SwiftUI

struct RouletteWheel: View {
    
    @ObservedObject var viewModel: RouletteViewModel
    
    var body: some View {
        ZStack {
            ForEach(0..<viewModel.prizes.count, id: \.self) { prizeIndex in
                PrizeView(
                    prizeIndex: prizeIndex,
                    numberOfPrizes: viewModel.prizes.count
                )
            }
        }
        .rotationEffect(
            .degrees(viewModel.rotationDegrees),
            anchor: .center
        )
        .animation(
            viewModel.spinning ? .easeInOut(duration: TimeInterval(viewModel.animationDuration)) : .none
        )
    }
    
}

struct PrizeView: View {
    
    let prizeIndex: Int
    let numberOfPrizes: Int
    
    var body: some View {
        let degreesPerPrize = 360.0 / Double(numberOfPrizes)
        let startAngle = Angle(degrees: degreesPerPrize * Double(prizeIndex))
        let endAngle = Angle(degrees: degreesPerPrize * Double(prizeIndex + 1))
        let sectorMidAngle = Angle(degrees: (degreesPerPrize * Double(prizeIndex) + degreesPerPrize * Double(prizeIndex + 1)) / 2.0)
        
        return Path { path in
            path.move(to: CGPoint(x: 150, y: 150))
            path.addArc(center: CGPoint(x: 150, y: 150), radius: 150, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
        .fill(Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1)))
        .overlay(
            Text(
                Prize(rawValue: prizeIndex)!.emoji()
            )
            .font(.largeTitle)
            .rotationEffect(sectorMidAngle + .degrees(90))
            .position(x: 150 + (cos(sectorMidAngle.radians) * 100), y: 150 + (sin(sectorMidAngle.radians) * 100))
        )
    }
    
}

#Preview {
    RouletteWheel(
        viewModel: RouletteViewModel(
            selectedPrize: .heart, rouletteCase: nil
        )
    )
}
