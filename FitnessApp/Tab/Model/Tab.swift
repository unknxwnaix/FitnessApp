//
//  Tab.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 4/19/25.
//

import Foundation

enum Tab: String, CaseIterable {
    case home = "house.fill"
    case charts = "chart.line.uptrend.xyaxis"
    case leaderboard = "trophy.fill"
    case profile = "person.fill"
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .charts:
            return "Charts"
        case .leaderboard:
            return "Leaderboard"
        case .profile:
            return "Profile"
        }
    }
}


/// Animated SF Tab Model
struct AnimatedTab: Identifiable {
    var id = UUID()
    var tab: Tab
    var isAnimating: Bool?
}
