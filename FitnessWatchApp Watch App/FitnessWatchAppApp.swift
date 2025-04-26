//
//  FitnessWatchAppApp.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

@main
struct FitnessWatchAppApp: App {
    @State private var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FitnessTabView()
                    .environment(workoutManager)
            }
        }
    }
} 
