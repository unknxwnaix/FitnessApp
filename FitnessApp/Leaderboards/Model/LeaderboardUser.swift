//
//  LeaderboardUser.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/10/25.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable, Equatable {
    var id = UUID()
    let username: String
    let count: Int
}
