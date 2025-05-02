//
//  TabView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
//

import SwiftUI

struct FitnessTabView: View {
    @Environment(WorkoutManager.self) private var workoutManager
    @State private var selectedTab = "Home"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .animation(.bouncy, value: selectedTab)
                .tag("Home")
            
            ActivitiesView()
                .animation(.bouncy, value: selectedTab)
                .tag("WeelkyActivities")
            
            WorkoutView()
                .animation(.bouncy, value: selectedTab)
                .tag("Workouts")
        }
    }
}

#Preview {
    FitnessTabView()
        .environment(WorkoutManager())
}
