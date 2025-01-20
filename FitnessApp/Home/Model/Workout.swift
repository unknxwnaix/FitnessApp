//
//  Workout.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import Foundation
import SwiftUI

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
