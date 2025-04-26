//
//  DatabaseManager.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 3/10/25.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    private let database = Firestore.firestore()
    let weeklyLeaderboard = "\(Date().mondayDateFormat())-leaderboard"
    
    //MARK: Fetch Leaderboards
    func fetchLeaderboards() async throws -> [LeaderboardUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderboardUser.self)})
    }
    
    //MARK: Post (Update) Leaderboards for current User
    func postStepCountUpdate(leader: LeaderboardUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
    
    //MARK: Update current Username
    func updateUsername(oldUsername: String, newUsername: String) async throws {
        let document = try await database.collection(weeklyLeaderboard).document(oldUsername).getDocument()
        try await database.collection(weeklyLeaderboard).document(newUsername).setData(document.data()!, merge: false)
        try await database.collection(weeklyLeaderboard).document(oldUsername).delete()
    }
}


//MARK: Generate 10 random users in FB
extension DatabaseManager {
    func createRandomUsers() async throws {
        let usersCollection = database.collection(weeklyLeaderboard)
        
        let usernames = ["aiX", "jason dubbon", "sean allen", "lev", "hacking with swift", "max", "olga", "daniel", "elena", "sergey"]
        
        for username in usernames {
            let randomSteps = Int.random(in: 5000...20000)
            let user = LeaderboardUser(username: username, count: randomSteps)
            
            let data = try Firestore.Encoder().encode(user)
            try await usersCollection.document(username).setData(data, merge: false)
        }
        
        print("10 случайных пользователей добавлены в Firestore")
    }
}
