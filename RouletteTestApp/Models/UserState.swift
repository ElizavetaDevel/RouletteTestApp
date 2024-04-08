//
//  UserState.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import Foundation

struct UserState: Codable, Hashable {
    
    var installDate: Date
    var daysInstalled: Int
    var prizeTaken: Int?
    
    static func == (lhs: UserState, rhs: UserState) -> Bool {
        return lhs.installDate == rhs.installDate &&
        lhs.daysInstalled == rhs.daysInstalled &&
        lhs.prizeTaken == rhs.prizeTaken
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(installDate)
        hasher.combine(daysInstalled)
        hasher.combine(prizeTaken)
    }
    
}
