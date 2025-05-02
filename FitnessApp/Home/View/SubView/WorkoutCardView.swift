//
//  WorkoutCardView.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI

struct WorkoutCardView: View {
    @State var workout: Workout
    
    var body: some View {
        HStack {
            Image(systemName: workout.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundStyle(workout.tintColor)
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(15)
            
            VStack (alignment: .leading, spacing: 16) {
                HStack {
                    Text(workout.title)
                        .font(.title3)
                        .bold()
                }
                
                HStack {
                    Label(workout.duration, systemImage: "clock")
                        .font(.caption)
                    
                    Spacer()
                    
                    Label(workout.calories, systemImage: "flame.fill")
                        .font(.caption)
                    Spacer()
                    
                    Label(workout.date, systemImage: "calendar")
                        .font(.caption)                }
            }
            .padding()
        }
    }
}

#Preview {
    WorkoutCardView(
        workout: Workout(
            title: "Running",
            image: "figure.run",
            tintColor: Color.fitnessGreenMain,
            duration: "47 mins",
            date: "3 aug",
            calories: "181 kcal"
        )
    )
}
