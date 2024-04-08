//
//  RouletteCase.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import Foundation

struct RouletteCase: Codable, Hashable {
    
    ///key is installation day
    /// value is corresponding prize
    let prizeForDay: [Int : Prize]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(prizeForDay)
    }
    
    static func == (lhs: RouletteCase, rhs: RouletteCase) -> Bool {
        return lhs.prizeForDay == rhs.prizeForDay
    }
    
}
