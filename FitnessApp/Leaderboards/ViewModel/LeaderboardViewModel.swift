//
//  LeaderboardViewModel.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/10/25.
//

import Foundation

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var leaderResult = LeaderboardResult(user: nil, top10: [])
    
    var mockData: [LeaderboardUser] = [
        LeaderboardUser(username: "aiX", count: 12345),
        LeaderboardUser(username: "jason dubbon", count: 12345),
        LeaderboardUser(username: "sean allen", count: 12345),
        LeaderboardUser(username: "lev", count: 12345),
        LeaderboardUser(username: "hacking with swift", count: 12345),
        LeaderboardUser(username: "aiX", count: 12345),
        LeaderboardUser(username: "jason dubbon", count: 12345),
        LeaderboardUser(username: "sean allen", count: 12345),
        LeaderboardUser(username: "lev", count: 12345),
        LeaderboardUser(username: "hacking with swift", count: 12345),
    ]
    
    struct LeaderboardResult {
        let user: LeaderboardUser?
        let top10: [LeaderboardUser]
    }
    
    init() {
        Task {
            do {
                try await setupLeaderboardData()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func setupLeaderboardData() async throws {
        try await postStepCountUpdateForUser()
        let result = try await fetchLeaderboard()
        DispatchQueue.main.async {
            self.leaderResult = result
        }
    }
    
    private func fetchLeaderboard() async throws -> LeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchLeaderboards()
        let top10 = Array(leaders.sorted { $0.count > $1.count }.prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username, !top10.contains(where: { $0.username == username }) {
            let user = leaders.first(where: { $0.username == username })
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    private func postStepCountUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else { throw URLError(.badURL) }
        let steps = try await fetchCurrentWeekStepCount()
        
        let leader = LeaderboardUser(username: username, count: Int(steps))
        try await DatabaseManager.shared.postStepCountUpdate(leader: leader)
    }
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation { continuation in
            HealthManager.shared.fetchCurrentWeekStepCount { result in
                continuation.resume(with: result)
            }
        }
    }
    
    public func updateUsername(oldUsername: String, newUsername: String) async throws {
        try await DatabaseManager.shared.updateUsername(oldUsername: oldUsername, newUsername: newUsername)
        let result = try await fetchLeaderboard()
        DispatchQueue.main.async {
            self.leaderResult = result
        }
    }
}
