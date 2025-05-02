//
//  HomeViewModel.swift
//  FitnessApp
//
//  Created by Maxim Dmitrochenko on 1/20/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    public var calories: Int = 0
    public var exercise: Int = 0
    public var stand: Int = 0
    
    @Published public var caloriesDisplay: Int = 0
    @Published public var exerciseDisplay: Int = 0
    @Published public var standDisplay: Int = 0
    
    public var caloriesGoal: Int = 460
    public var activityGoal: Int = 30
    public var standGoal: Int = 12
    
    public var caloriesColor: Color = .fitnessRedMain
    public var activityColor: Color = .fitnessGreenMain
    public var standColor: Color = .fitnessBlueMain
    
    @Published var activities = [FitnessActivity]()
    
    @Published var workouts = [
        Workout(
            title: "Running",
            image: "figure.run",
            tintColor: Color.fitnessGreenMain,
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
    
    let healthManager = HealthManager.shared
    
    
    init() {
        Task {
            do {
                try await healthManager.reguestHealthKitAccess()
                
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
                fetchTodaySteps()
                fetchCurrentWeekActivities()
                fetchRecentWorkouts()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                    let activity = FitnessActivity(title: "Calories Burned", subtitle: "today", image: "flame.fill", tintColor: .red, amount: calories.formattedNumberString())
                    self.activities.append(activity)
                }
            }
        }
    }
    
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            }
        }
    }
    
    func fetchTodayStandHours() {
        healthManager.fetchTodayStandHours { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = hours
                }
            }
        }
    }
    
    // MARK: Fitness Activity
    func fetchTodaySteps() {
        healthManager.fetchTodaySteps { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            }
        }
    }
    
    func fetchCurrentWeekActivities() {
        healthManager.fetchCurrentWeekWorkoutStats { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                }
            }
        }
    }
    
    func fetchRecentWorkouts() {
        healthManager.fetchWorkoutsForMonth(month: Date()) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = Array(workouts.prefix(4))
                }
            }
        }
    }
}
