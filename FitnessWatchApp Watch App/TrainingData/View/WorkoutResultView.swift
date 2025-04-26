//
//  WorkoutResultView.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/26/25.
//

import SwiftUI

struct WorkoutResultView: View {
    @Environment(WorkoutManager.self) private var workoutManager

    var body: some View {
        
        if let result = workoutManager.workoutResult {
            ScrollView {

                HKWorkoutView(workout: result)
                
                Spacer()
                    .frame(height: 8)
                
                Button(action: {
                    workoutManager.showResult = false
                }, label: {
                   Text("Завершить")
                })
                .tint(.fitnessGreenMain)

            }
        }
    }
}

#Preview {
    WorkoutResultView()
        .environment(WorkoutManager())
}
