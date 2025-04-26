//
//  HomeViewModel.swift
//  FitnessWatchApp Watch App
//
//  Created by Maxim Dmitrochenko on 4/21/25.
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
    
    let healthManager = HealthManager.shared
    
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
                
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
                    let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame.fill", tintColor: .red, amount: calories.formattedNumberString())
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
}
