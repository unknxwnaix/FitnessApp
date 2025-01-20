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
            tintColor: .green,
            duration: "47 mins",
            date: "3 aug",
            calories: "181 kcal"
        )
    )
}

struct Workout: Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let tintColor: Color
    let duration: String
    let date: String
    let calories: String
}

extension Workout {
    static var mockWorkouts: [Workout] = [
        Workout(
            title: "Running",
            image: "figure.run",
            tintColor: .green,
            duration: "47 mins",
            date: "Aug 19",
            calories: "502 kcal"
        ),
        
        Workout(
            title: "Strength Training",
            image: "figure.run",
            tintColor: .cyan,
            duration: "51 mins",
            date: "Aug 11",
            calories: "512 kcal"
        ),
        
        Workout(
            title: "Walk",
            image: "figure.walk",
            tintColor: .pink,
            duration: "60 mins",
            date: "Aug 3",
            calories: "211 kcal"
        ),
        
        Workout(
            title: "Running",
            image: "figure.run",
            tintColor: .yellow,
            duration: "60 mins",
            date: "Aug 1",
            calories: "712 kcal"
        )
    ]
}
