//
//  Prize.swift
//  RouletteTestApp
//
//  Created by superuser on 4/8/24.
//

import Foundation

enum Prize: Int, Codable {
    
    case heart, fire, star, thumbsUp, sunglasses
    
    static var allCases: [Prize] {
        return [.heart, .fire, .star, .thumbsUp, .sunglasses]
    }
    
    func emoji() -> String {
        switch self {
        case .heart:
            return "❤️️️️️️️"
        case .fire:
            return "🔥️️️️️️"
        case .star:
            return "⭐️"
        case .thumbsUp:
            return "👍️️️️️️"
        case .sunglasses:
            return "😎"
        }
    }
    
}
